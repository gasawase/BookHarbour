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



//class WebViewController: UIViewController, WKNavigationDelegate {
//    // WKWebView to display HTML content
//    private var webView: WKWebView!
//
//    // Override loadView to set up the view hierarchy
//    override func loadView() {
//        // Create a WKWebView and set it as the view of the view controller
//        webView = WKWebView()
//        webView.navigationDelegate = self
//        view = webView
//    }
//
//    // Load HTML content from a file into the WKWebView
//    func loadHTMLFromFile(_ filePath: String) {
//        // Read HTML content from the file path
////        if let htmlString = try? String(contentsOfFile: filePath, encoding: .utf8) {
////            // Load the HTML string into the WKWebView
////            webView.loadHTMLString(htmlString, baseURL: nil)
////        }
//    }
//}

struct HTMLView: UIViewRepresentable {
//    let htmlFileName: String
    @Binding var chapterPath : String
    
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
        preferences.allowsContentJavaScript = true // Enable JavaScript execution
        webView.configuration.defaultWebpagePreferences = preferences
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let htmlPath = chapterPath
        //just loading the file
        
        do{
            // Read HTML file content
            let htmlContent = try String(contentsOfFile: htmlPath, encoding: .utf8)
            
            // Parse HTML using SwiftSoup
            //let document = try SwiftSoup.parse(htmlContent)
            
            // Get the final HTML content
            //let finalHtml = try document.outerHtml()
            let chapterPathURL = URL(fileURLWithPath: chapterPath)
            let parentURL = chapterPathURL.deletingLastPathComponent()
            uiView.loadFileURL(chapterPathURL, allowingReadAccessTo: parentURL)
            
        }catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("error")
        }
        
//        let chapterPathURL = URL(fileURLWithPath: chapterPath)
        
//        uiView.loadFileURL(chapterPathURL, allowingReadAccessTo: chapterPathURL)
    }
    
}

