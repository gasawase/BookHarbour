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
    //@State var base64Image : String = ""
    
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
        //injectCSS(uiView: uiView, cssFileName: "defaultStylesheet")

        print("updateUIView run")
        var isSVG = false
        let htmlPath = chapterPath
        print("chapter path \(chapterPath)")
        let fileManager = FileManager.default
        //var imgNewURL : URL = URL(filePath: "")
        var base64Image : String = ""
        var imgSrc : String = ""
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
                print("image")
                isSVG = true
                if imgRefs.isEmpty() {
                    imgRefs = try doc.select("svg")
                    isSVG = true
                    print("svg")
                }
            }
            
            let fontSize = readerSettings.fontSize
            let fontFamily = readerSettings.fontFamily
            
            try doc.select("body").attr("style", "font-size: \(fontSize)px; font-family: '\(fontFamily)', serif; padding: 5pt; img{ display: block; text-align: center; text-indent: 0; margin: 0}")
//            try doc.select("body").attr("style", "font-family: '\(fontFamily)', serif;")
//            try doc.select("body").attr("style", "padding: 5pt;")
            // Create a mutable copy of the HTML string
            var modifiedHtmlString = try doc.outerHtml()
            // Iterate through each image reference
            for imgRef in imgRefs {
                if isSVG == true{
                    imgSrc = try imgRef.attr("xlink:href")
                }
                else{
                    imgSrc = try imgRef.attr("src")

                }
                var newImgSrc = imgSrc
                var brokenURL = URL(filePath: imgSrc).pathComponents
                if brokenURL.count > 2{
                    var deleteFirst = brokenURL.remove(at: 1)
                    deleteFirst = brokenURL.remove(at: 0)
                    let joinedPath = brokenURL.joined(separator: "/")
                    newImgSrc = joinedPath
                }
                
                /// find where the imgSrc matches the entry in the manifest
                let searchResults = currentBook.manifestDictionary.filter({ $0.value.contains(newImgSrc) })
                if searchResults.count != 0 {
                    let firstSearchResult = searchResults.first?.value
                    var imgNewURL = URL(filePath: "")
                    if firstSearchResult != nil, let validSearch = firstSearchResult{
                        if ReaderView().isPathValid(currentBook.bookEpubPath.appending(validSearch)){
                            imgNewURL = URL(filePath: currentBook.bookEpubPath.appending(validSearch))

                        }
                        else{
                            let parentOPF = currentBook.bookOPFURL
                            let removeOPFRef = parentOPF.deletingLastPathComponent()
                            let newFilePath = removeOPFRef.path()
                            imgNewURL = URL(filePath: newFilePath.appending(validSearch))
                        }
                        if let imageData = try? Data(contentsOf: imgNewURL) {
                            base64Image = imageData.base64EncodedString()
                        }
                    }
                }
                // Replace the image source in the HTML string with the base64 image data
                modifiedHtmlString = modifiedHtmlString.replacingOccurrences(of: imgSrc, with: "data:image/*;base64,\(base64Image)")

            }
            uiView.loadHTMLString(modifiedHtmlString, baseURL: nil)
            
            //injectCSS(uiView: uiView, cssFileName: "defaultStylesheet")
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
    
//    func injectCSS(uiView: WKWebView, cssFileName: String) {
//        guard let cssPath = Bundle.main.path(forResource: cssFileName, ofType: "css"),
//              let cssString = try? String(contentsOfFile: cssPath, encoding: .utf8) else {
//            print("Failed to load CSS file")
//            return
//        }
//        
//        let formattedCSS = cssString.replacingOccurrences(of: "\n", with: "")
//        let jsString = """
//            var style = document.createElement('style');
//            style.innerHTML = '\(formattedCSS)';
//            document.head.appendChild(style);
//            """
//        
//        uiView.evaluateJavaScript(jsString, completionHandler: nil)
//    }
    
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

