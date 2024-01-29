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

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let htmlPath = chapterPath
        //just loading the file
        let chapterPathURL = URL(fileURLWithPath: chapterPath)
        uiView.loadFileURL(chapterPathURL, allowingReadAccessTo: chapterPathURL)
    }
}
