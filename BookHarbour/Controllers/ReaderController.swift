import SwiftUI
import WebKit
import SwiftSoup

struct HTMLView: UIViewRepresentable {
    @EnvironmentObject var currentBook: CurrentBook
    @Binding var chapterPath: String
    @ObservedObject var readerSettings: ReaderSettings

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        injectCSS(webView: webView)

        return webView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: HTMLView

        init(_ parent: HTMLView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Inject CSS after content is loaded
            parent.injectCSS(webView: webView)
        }
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let htmlPath = chapterPath
        do {
            let htmlString = try String(contentsOfFile: htmlPath, encoding: .utf8)
            let modifiedNewHTMLString = extractImageRefs(htmlContent: htmlString)
            print("modifiedNewHtmlString:  \(modifiedNewHTMLString)")
            if (modifiedNewHTMLString == "")
            {
                uiView.loadHTMLString(htmlString, baseURL: URL(fileURLWithPath: htmlPath))

            }
            else{
                uiView.loadHTMLString(modifiedNewHTMLString, baseURL: URL(fileURLWithPath: htmlPath))

            }
        } catch {
            print("Error loading HTML file: \(error)")
        }
        
        injectCSS(webView: uiView)
    }
    
    public func extractImageRefs(htmlContent: String) -> String{
        var modifiedHtmlString : String = ""
        var isSVG = false
        var base64Image : String = ""
        var imgSrc : String = ""
        do{
            let doc : Document = try SwiftSoup.parse(htmlContent)
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
                modifiedHtmlString = htmlContent.replacingOccurrences(of: imgSrc, with: "data:image/*;base64,\(base64Image)")

            }
        } catch {
            print("Error loading: \(error)")
        }
        return modifiedHtmlString
    }

    public func injectCSS(webView: WKWebView) {
        let cssFileName = "defaultCss.css"
        guard let cssPath = Bundle.main.path(forResource: cssFileName, ofType: nil),
              let cssString = try? String(contentsOfFile: cssPath, encoding: .utf8) else {
            fatalError("Failed to load CSS file.")
        }

        let fontSize = "\(readerSettings.fontSize)pt"
        let fontFamily = "\(readerSettings.fontFamily)"
        print(fontSize)
        let jsString = """
            var style = document.createElement('style');
            style.innerHTML = `\(cssString) body { font-size: \(fontSize); font-family: \(fontFamily)}`;
            document.head.appendChild(style);
            """
        webView.evaluateJavaScript(jsString, completionHandler: nil)
    }


}

class CustStopwatch: ObservableObject {
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

//struct ImageData {
//    var base64Image: String
//    var imgSrc: String
//    var isSVG: Bool
//}
//
//func extractImageReferences(from htmlPath: String) -> ImageData? {
//    var isSVG = false
//    let fileManager = FileManager.default
//    var base64Image: String = ""
//    var imgSrc: String = ""
//
//    do {
//        let htmlString = try String(contentsOfFile: htmlPath)
//        let doc: Document = try SwiftSoup.parse(htmlString)
//        
//        // Get image references
//        var imgRefs: Elements = try doc.select("img")
//        if imgRefs.isEmpty {
//            imgRefs = try doc.select("image")
//            isSVG = !imgRefs.isEmpty
//        }
//        if imgRefs.isEmpty {
//            imgRefs = try doc.select("svg")
//            isSVG = !imgRefs.isEmpty
//        }
//
//        // Log the type of image tags found
//        if isSVG {
//            print("SVG type image found")
//        }
//
//        // Here you could extract src or other attributes if needed
//        // For example:
//        if let img = imgRefs.array().first {
//            imgSrc = try img.attr("src")
//        }
//
//        // Return the data found
//        return ImageData(base64Image: base64Image, imgSrc: imgSrc, isSVG: isSVG)
//    } catch {
//        print("Failed to parse HTML: \(error)")
//        return nil
//    }
//}
