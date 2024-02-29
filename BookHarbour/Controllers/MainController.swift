//
//  MainController.swift
//  BookHarbour
//
//  Created by Summer Gasaway on 1/2/24.
//

import Foundation
import SWXMLHash
import UIKit
import SwiftUI
import SwiftSoup

class MainController: ObservableObject{
    let dataController = DataController.shared

    func updateFontInHTMLString(_ htmlString: String, withFontSize newSize: Int, fontFamily newFamily: String) -> String {
        do {
            let doc: Document = try SwiftSoup.parse(htmlString)
            
            // Find elements with a 'style' attribute
            let elementsWithStyle: Elements = try doc.select("[style]")
            // Exit if no elements with 'style' attribute
            if elementsWithStyle.isEmpty() {
                // Check for <font> tags before deciding to exit early
                let fontElements: Elements = try doc.select("font[size]")
                if fontElements.isEmpty() {
                    return htmlString // No elements to update, return original string
                }
            } else {
                // Update font size in elements with 'style' attribute
                for element in elementsWithStyle.array() {
                    let style = try element.attr("style")
                    let updatedStyleWithSize = style.replacingOccurrences(of: "font-size:\\s*\\d+\\s*(px|em|%|pt);?", with: "font-size: \(newSize)px;", options: .regularExpression, range: nil)
                    let updatedStyleWithFamily = updatedStyleWithSize.replacingOccurrences(of: "font-family:[^;]+;", with: "font-family: '\(newFamily)', serif;", options: .regularExpression, range: nil)

                    try element.attr("style", updatedStyleWithFamily)
                }
            }
            
            // Update 'size' attribute in <font> tags if they exist
            let fontElements: Elements = try doc.select("font[size]")
            for fontElement in fontElements.array() {
                try fontElement.attr("size", "\(newSize)")
            }
            
            return try doc.outerHtml()
        } catch Exception.Error(let type, let message) {
            print("SwiftSoup error: \(type) \(message)")
        } catch {
            print("error: \(error)")
        }
        return htmlString
    }

}

enum BookHarbourErrorType : Error{
    case titleNil
    case authorNil
    case missingOPFPath
    case missingOPFURL
    case missingUID
    case missingInfo(String)
    case ebookNil
}

class OPFParser {
    static func parseManifestItems(opfURL: URL) -> [String: String]? {
        guard let opfXMLData = FileManager.default.contents(atPath: opfURL.path) else {
            print("Failed to read OPF file at \(opfURL)")
            return nil
        }

        do {
            let opfXML = XMLHash.lazy(opfXMLData)
            var manifestItems: [String: String] = [:]

            for elem in opfXML["package"]["manifest"]["item"].all {
                if let itemId = elem.element?.attribute(by: "id")?.text,
                   let href = elem.element?.attribute(by: "href")?.text {
                    manifestItems[itemId] = href
                }
            }

            return manifestItems
        } catch {
            print("Error parsing OPF XML: \(error)")
            return nil
        }
    }
}

class AppState: ObservableObject {
    @Published var showBookDetails: Bool = false
    @Published var showReaderView: Bool = false
    @Published var showTestingView: Bool = false
}

class CurrentBook: ObservableObject {
    @Published var bookTitle : String = ""
    @Published var bookAuthor : String = ""
    @Published var currentChapter : Int = 1
    @Published var bookOPFPath : String = ""
    @Published var bookOPFURL : URL = URL(fileURLWithPath: "/path/to/file.txt")
    @Published var bookUID : UUID = UUID()
    @Published var readingProgressSeconds : Int = 0
    @Published var manifestDictionary : [String: String] = [:]
    @Published var bookEpubPath : String = ""
    // current location in book
    
}

class NumOfBooks : ObservableObject {
    @Published var numOFBooks : Int = 0
}

class LoadingScreenManagerViewModel {
    
    static let shared = LoadingScreenManagerViewModel()
    
    private var isShowing = false
    
    private init() {} // Private initialization to ensure singleton usage
    
    func showLoadingScreen<Content: View>(content: Content) -> some View {
        isShowing = true
        return ZStack {
            content
            if isShowing {
                VStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
                .background(Color.black.opacity(0.3).edgesIgnoringSafeArea(.all))
            }
        }
    }
    
    func hideLoadingScreen() {
        isShowing = false
    }
}


class LoadingScreenManagerViewController {
    
    static let shared = LoadingScreenManagerViewController()
    
    private var backdropView: UIView?
    private var activityIndicator: UIActivityIndicatorView?
    
    private init() {} // Private initialization to ensure singleton usage
    
    func showLoadingScreen(over viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        
        DispatchQueue.main.async {
            self.backdropView = UIView(frame: viewController.view.bounds)
            self.backdropView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
            self.activityIndicator = UIActivityIndicatorView(style: .large)
            self.activityIndicator?.center = self.backdropView!.center
            self.activityIndicator?.startAnimating()
            
            self.backdropView?.addSubview(self.activityIndicator!)
            viewController.view.addSubview(self.backdropView!)
        }
    }
    
    func hideLoadingScreen() {
        DispatchQueue.main.async {
            self.activityIndicator?.stopAnimating()
            self.backdropView?.removeFromSuperview()
        }
    }
}
    


extension Optional {
    func unwrap( variableName: String) throws -> Wrapped {
        guard let unwrapped = self else {
            throw BookHarbourErrorType.missingInfo("\(variableName) is missing")
        }
        return unwrapped
    }
}

extension String {
    func attributedStringFromHTML() -> NSAttributedString {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
}


