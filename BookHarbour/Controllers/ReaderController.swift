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
//        if let htmlPath = Bundle.main.path(forResource: htmlFileName, ofType: "xhtml") {
        
        //just loading the file
        let chapterPathURL = URL(fileURLWithPath: chapterPath)
        uiView.loadFileURL(chapterPathURL, allowingReadAccessTo: chapterPathURL)
        
        // converting to a string
//            do {
//                let htmlString = try String(contentsOfFile: htmlPath, encoding: .utf8)
//                uiView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
//            } catch {
//                print("Error loading HTML file: \(error)")
//            }
//        }
    }
}

//class WebViewModel: NSObject, ObservableObject, WKNavigationDelegate {
//    @Published var isLoading: Bool = true
//
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        isLoading = false
//    }
//}
//
//struct HTMLView: UIViewRepresentable {
//    let htmlPath: String
//
//    @ObservedObject var viewModel = WebViewModel()
//
//    func makeUIView(context: Context) -> WKWebView {
//        let webView = WKWebView()
//        webView.navigationDelegate = context.coordinator
//        if let htmlURL = Bundle.main.url(forResource: htmlPath, withExtension: "xhtml") {
//            let request = URLRequest(url: htmlURL)
//            webView.load(request)
//        }
//        return webView
//    }
//
//    func updateUIView(_ uiView: WKWebView, context: Context) {
//        // You can add any additional updates here if needed
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, WKNavigationDelegate {
//        var parent: HTMLView
//
//        init(_ parent: HTMLView) {
//            self.parent = parent
//        }
//
//        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            parent.viewModel.isLoading = false
//        }
//    }
//
//    var loadingIndicator: some View {
//        VStack {
//            if viewModel.isLoading {
//                ProgressView()
//                    .progressViewStyle(CircularProgressViewStyle())
//                    .padding()
//            }
//        }
//    }
//}

// SwiftUI UIViewControllerRepresentable to host the WebViewController
//struct WebViewContainer: UIViewControllerRepresentable {
//    // HTML file path to be loaded into the WebView
//    let htmlFilePath: String
//
//    // Create the WebViewController and set up the initial state
//    func makeUIViewController(context: Context) -> WebViewController {
//        let webViewController = WebViewController()
//        webViewController.loadHTMLFromFile(htmlFilePath)
//        return webViewController
//    }
//
//    // Update the view controller if needed (not used in this example)
//    func updateUIViewController(_ uiViewController: WebViewController, context: Context) {
//        // Update the view controller if needed
//    }
//}

// functionality to get the last place of the reader
//      if the book has not been read before, then start at the beginning
