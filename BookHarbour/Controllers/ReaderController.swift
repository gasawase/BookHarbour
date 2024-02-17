//
//  ReaderController.swift
//  BookHarbour
//
//  Created by Summer Gasaway on 1/2/24.
//

import Foundation
import SwiftUI
import UIKit
import WebKit
import SwiftSoup


class ReaderController : ObservableObject{
    //@EnvironmentObject var currentBook : CurrentBook
}

struct HTMLView: UIViewRepresentable {
//    let htmlFileName: String
    @EnvironmentObject var currentBook : CurrentBook
    @Binding var chapterPath : String
    @ObservedObject var readerSettings : ReaderSettings
    
    func listFilesInFolder(_ folderURL: URL) {
        do {
            let fileManager = FileManager.default
            let contents = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
            for fileURL in contents {
                print(fileURL.lastPathComponent)
            }
        } catch {
            print("Error listing files: \(error)")
        }
    }
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        webView.configuration.defaultWebpagePreferences = preferences
        webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        print("updateUIView run")
        let htmlPath = chapterPath
        do {
            let htmlString = try String(contentsOfFile: htmlPath)
            let doc : Document = try SwiftSoup.parse(htmlString)
            let docOuter = try doc.outerHtml() // shows the outer HTML...duh
            //let docText = try doc.text() // shows just the text as regular without formatting

            var imgRefs: Elements

            // Try selecting "img" tags first
            imgRefs = try doc.select("img")

            // If no "img" tags found, try selecting "image" tags
            if imgRefs.isEmpty() {
                imgRefs = try doc.select("image")
                print(imgRefs.array())
            }
            
            let fontSize = readerSettings.fontSize
            try doc.select("body").attr("style", "font-size: \(fontSize)px;")
            // Create a mutable copy of the HTML string
            var modifiedHtmlString = try doc.outerHtml()
            // Iterate through each image reference
            for imgRef in imgRefs {
                var imgSrc = try imgRef.attr("src")
                // find where the imgSrc matches the entry in the manifest
//                print("Image Ref: \(imgRef)")
//                print(currentBook.manifestDictionary)
                if let matchingImg = (currentBook.manifestDictionary.first(where: {$0.value == imgSrc})?.value) {
                    print(matchingImg)
                    let chapterPathURL = URL(fileURLWithPath: chapterPath)
                    let parentURL = chapterPathURL.deletingLastPathComponent()
                    let imgNewURL = parentURL.appending(path: matchingImg)
                    if let imageData = try? Data(contentsOf: imgNewURL) {
                        // Convert the image data to a base64 string
                        let base64Image = imageData.base64EncodedString()
                        
                        // Replace the image source in the HTML string with the base64 image data
                        modifiedHtmlString = modifiedHtmlString.replacingOccurrences(of: imgSrc, with: "data:image/*;base64,\(base64Image)")
                    }
                }
            }
            
            //print(currentBook.manifestDictionary)
            uiView.loadHTMLString(modifiedHtmlString, baseURL: nil)

//
//            uiView.loadFileURL(chapterPathURL, allowingReadAccessTo: nextParentURL)

        } catch {
            print("Error loading HTML file: \(error)")
        }
    }
        
    
    // BASIC READING AND WORKS
//    func makeUIView(context: Context) -> WKWebView {
//        let webView = WKWebView()
//        let preferences = WKWebpagePreferences()
//        preferences.allowsContentJavaScript = true
//        webView.configuration.defaultWebpagePreferences = preferences
//        return webView
//    }
//    
//    func updateUIView(_ uiView: WKWebView, context: Context) {
//        print("updateUIView run")
//        let htmlPath = chapterPath
//        do {
//            let chapterPathURL = URL(fileURLWithPath: chapterPath)
//            let parentURL = chapterPathURL.deletingLastPathComponent()
//            let nextParentURL = parentURL.deletingLastPathComponent()
//
//            uiView.loadFileURL(chapterPathURL, allowingReadAccessTo: nextParentURL)
//
//        } catch {
//            print("Error loading HTML file: \(error)")
//        }
//    }
    
    private func readFileBy(name: String, type: String) -> String {
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            return "Failed to find path"
        }
        
        do {
            return try String(contentsOfFile: path, encoding: .utf8)
        } catch {
            return "Unkown Error"
        }
    }
    
    func injectToPage(webView: WKWebView) {
        let cssFile = readFileBy(name: "defaultStylesheet", type: "css")

        let cssScript = WKUserScript(source: cssFile, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        
        webView.configuration.userContentController.addUserScript(cssScript)
    }
    
    // Function to change font size externally
    func changeFontSize(_ size: CGFloat, webView: WKWebView) {
        readerSettings.fontSize = size
        let script = """
        document.getElementsByTagName('body')[0].style.fontSize = '\(size)px';
        """
        webView.evaluateJavaScript(script, completionHandler: nil)
    }
}

// have a function that is running keep track of time read and then when readview is closed, have it write that number to the ebook's time read section
// will also need a button/ ability for a user to choose to remove or delete their tracking time
// eventually, when the user finishes the book, have it give them the option to leave a review
// also need a way for their reading time to be written to their book modal

class CustStopwatch: ObservableObject {
    // TODO: need to create the ability to save the FIRST first start date and then the stop date. Does this go here?
    @Published var elapsedTime: TimeInterval = 0
    private var startTime: Date?

    func start() {
        startTime = Date()
    }

    func stop() {
        
        guard let startTime = startTime else { return }
        elapsedTime += Date().timeIntervalSince(startTime)
        self.startTime = nil
    }

    func reset() {
        startTime = nil
        elapsedTime = 0
    }
}

