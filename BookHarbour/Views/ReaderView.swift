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
    @State private var chapterPath: String = ""
    @State private var currentChapterIndex: Int = 0
    @EnvironmentObject var currentBook: CurrentBook
    @StateObject var readerSettings = ReaderSettings()

    @State private var manifestItems: [String: String] = [:]
    @State private var spineItems: [String] = []
    //@State private var fontFamily
    
    @State var isShowingReadingMenu : Bool = false
    
    func previousChapter(){
        if currentChapterIndex > 0 {
            currentChapterIndex -= 1
        }
    }
    
    func nextChapter(){
        //print("next chapter run")
        //print(spineItems.count)
        if currentChapterIndex < (spineItems.count - 1){
            currentChapterIndex += 1
            print(currentChapterIndex)
        }
    }
    
    func getChapterPath(currentChapterIndex : Int) -> String{
        let opfURL : URL = currentBook.bookOPFURL
        //let opfURL = URL(string: opfPath)!
        spineItems = OPFTryGetData().getSpineItems(opfURL)
        //print(spineItems.count)
        manifestItems = OPFTryGetData().getManifestItems(opfURL)
        if currentChapterIndex < spineItems.count, let chapterPath = manifestItems[spineItems[currentChapterIndex]]
        {
            let currentPath = chapterPath
            let parentURL = opfURL
            let parentFilePath = parentURL.deletingLastPathComponent()
            let finalCoverURLPath = parentFilePath.appending(path: currentPath).path()
            
            return finalCoverURLPath
        }
        return "No chapter path"
    }
    
    var body: some View {
        ZStack{
            GeometryReader { geometry in
                VStack {
                    HTMLView(chapterPath: $chapterPath, readerSettings: readerSettings) // Use binding for chapterPath
                        .navigationBarTitle("HTML View", displayMode: .inline)
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height
                        )
                }
                .contentShape(Rectangle())
                .onTapGesture { tapLocation in
                    if !isShowingReadingMenu{
                        // Calculate the tap position relative to the screen width
                        let tapX = tapLocation.x
                        // Determine if the tap was on the left or right side of the screen
                        let screenWidth = geometry.size.width
                        let isLeftTap = tapX < screenWidth / 8
                        let isRightTap = tapX > (screenWidth * 2) / 2.2
                        // Update the current chapter index accordingly
                        if isLeftTap {
                            previousChapter()
                        } else if isRightTap {
                            nextChapter()
                        }
                    }
                }
            }
            VStack{
                if isShowingReadingMenu{
                    Spacer()
                    Group{
                        Button(action: {
                            appState.showReaderView.toggle()
                        }, label: {
                            Image(systemName: "books.vertical.circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                        })
                        // change attributes of the html view
                        Button(action: {
                            readerSettings.fontSize += 2
                        }, label: {
                            Text("Button")
                        })
                    }
                    .padding()
                    .background(Color.gray)
                    .clipShape(Circle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                }
                Button(action: {
                    withAnimation {
                        isShowingReadingMenu.toggle()
                    }
                }) {
                    Image(systemName: "ellipsis.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.gray)
                .clipShape(Circle())
                .shadow(radius: 5)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }
            .padding()
        }
        .onAppear {
            chapterPath = getChapterPath(currentChapterIndex: currentChapterIndex)
        }
        .onChange(of: currentChapterIndex) { _ in
            // Update the chapterPath when currentChapterIndex changes
            withAnimation {
                chapterPath = getChapterPath(currentChapterIndex: currentChapterIndex)
            }
        }
    }
}

class ReaderSettings: ObservableObject{
    @Published var fontSize : CGFloat = 32
}
