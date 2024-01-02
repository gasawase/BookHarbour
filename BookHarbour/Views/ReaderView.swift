//
//  ReaderView.swift
//  BookHarbour
//
//  Created by Summer Gasaway on 1/2/24.
//

import SwiftUI
import WebKit

struct ReaderView: View{
    //@State var readerController = ReaderController()
    //var ebook : Ebooks
    @EnvironmentObject var appState: AppState
    @State var chapterPath : String = ""
    @EnvironmentObject var currentBook : CurrentBook
    
    var body: some View{
        
//        NavigationStack {
//            NavigationLink(destination: Text("Destination")) { Text("Navigate")
//            }
//        }
        //WebViewContainer(htmlFilePath: chapterPath)
//        HTMLView(htmlPath: chapterPath)
//            .border(Color.red)
//            .foregroundColor(Color.black)
//            .frame(
//                width: 500
//            )
        HTMLView(htmlFileName: chapterPath)
                    .navigationBarTitle("HTML View", displayMode: .inline)
        Text("This is the current opf path: \(currentBook.bookOPFPath)")
        Text("and this is the chapter path: \(chapterPath)")
        Button("Switch to Main View") {
            appState.showReaderView.toggle()
        }
        .onAppear(perform: {
                var currentChapterNum = 3
                print("ReaderViewable")
            chapterPath = ChangingData(currentBook: currentBook).getChapterPath(currentChapterNumber: currentChapterNum)
                print(chapterPath)
            
            
            })
    }

}

struct ChangingData{
    
    var currentBook : CurrentBook
    
    //private var manifestItems: [String: String] = [:]
    //private var spineItems: [String] = []
    
    func getChapterPath(currentChapterNumber : Int) -> String{
        let opfURL : URL = currentBook.bookOPFURL
        //let opfURL = URL(string: opfPath)!
        let spineItems = OPFTryGetData().getSpineItems(opfURL)
        let manifestItems = OPFTryGetData().getManifestItems(opfURL)

        if currentChapterNumber < spineItems.count, let chapterPath = manifestItems[spineItems[currentChapterNumber]]
        {
            let currentPath = chapterPath
            let parentURL = opfURL
            let parentFilePath = parentURL.deletingLastPathComponent()
            let finalCoverURLPath = parentFilePath.appending(path: currentPath).path()
            
            return finalCoverURLPath
        }
        return "Nothing"
    }
}

//struct ReaderView: View {
//    let ebooksURL: URL
//
//    @State var readerController = ReaderController()
//
//    var body: some View {
//        HTMLView(ebooksURL: ebooksURL)
//    }
//}
