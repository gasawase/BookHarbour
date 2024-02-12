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
    @EnvironmentObject var currentBook : CurrentBook
}

struct HTMLView: UIViewRepresentable {
//    let htmlFileName: String
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

        // Inject JavaScript to set initial font size
//        let script = """
//        document.getElementsByTagName('body')[0].style.fontSize = '\(readerSettings.fontSize)px';
//        """
//        webView.evaluateJavaScript(script, completionHandler: nil)
//        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let customCSSFilePath = documentsDirectory.appendingPathComponent("defaultStylesheet.css")
//        let trashString = "as;kldf;asldkfj"
//        do{
//            try trashString.write(to: customCSSFilePath, atomically: true, encoding: .utf8)
//            print(try String(contentsOfFile: customCSSFilePath.path))
//        } catch {
//            print("Error exporting HTML: \(error)")
//        }


        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        print("updateUIView run")
        let htmlPath = chapterPath
        do {
            let chapterPathURL = URL(fileURLWithPath: chapterPath)
            let parentURL = chapterPathURL.deletingLastPathComponent()
            let nextParentURL = parentURL.deletingLastPathComponent()

            uiView.loadFileURL(chapterPathURL, allowingReadAccessTo: nextParentURL)
                // Inject JavaScript to adjust font size after content is loaded
                    let script = """
                    console.log("Applying font size adjustment");
                    var style = document.createElement('style');
                    style.innerHTML = 'body { font-size: \(readerSettings.fontSize)px !important; }';
                    document.head.appendChild(style);
                    """
            injectToPage(webView: uiView)
                //uiView.evaluateJavaScript(script, completionHandler: nil)
            //uiView.configuration.userContentController.addUserScript()

        } catch {
            print("Error loading HTML file: \(error)")
        }
    }
    
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

//    func updateUIView(_ uiView: WKWebView, context: Context) {
//        print("updateUIView run")
//        let htmlPath = chapterPath
//        do {
//            let chapterPathURL = URL(fileURLWithPath: chapterPath)
//            let parentURL = chapterPathURL.deletingLastPathComponent()
//            let nextParentURL = parentURL.deletingLastPathComponent()
//            let script = """
//            document.getElementsByTagName('html')[0].style.setProperty('font-size', readerSettings.fontSize + 'px', 'important');
//            """
//            uiView.evaluateJavaScript(script, completionHandler: nil)
//            uiView.loadFileURL(chapterPathURL, allowingReadAccessTo: nextParentURL)
//
//        } catch {
//            print("Error loading HTML file: \(error)")
//        }
//    }
    
    // Function to change font size externally
//    func changeFontSize(_ size: CGFloat, webView: WKWebView) {
//        readerSettings.fontSize = size
//        let script = """
//        document.getElementsByTagName('body')[0].style.fontSize = '\(size)px';
//        """
//        webView.evaluateJavaScript(script, completionHandler: nil)
//    }
}

