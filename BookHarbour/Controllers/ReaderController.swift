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
        let script = """
        document.getElementsByTagName('body')[0].style.fontSize = '\(readerSettings.fontSize)px';
        """
        webView.evaluateJavaScript(script, completionHandler: nil)

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
            let script = """
            document.getElementsByTagName('body')[0].style.fontSize = '\(readerSettings.fontSize)px';
            """
            uiView.evaluateJavaScript(script, completionHandler: nil)
            print(readerSettings.fontSize)
        } catch {
            print("Error loading HTML file: \(error)")
        }
//        let htmlPath = chapterPath
//        //just loading the file
//        do{
//            let chapterPathURL = URL(fileURLWithPath: chapterPath)
//            let parentURL = chapterPathURL.deletingLastPathComponent()
//            let nextParentURL = parentURL.deletingLastPathComponent()
//            print(parentURL)
//            print(nextParentURL)
//            uiView.loadFileURL(chapterPathURL, allowingReadAccessTo: nextParentURL)
//            
//        }catch Exception.Error(let type, let message) {
//            print(message)
//        } catch {
//            print("error")
//        }
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

