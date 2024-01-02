//
//  BookDetailsModalView.swift
//  BookHarbour
//
//  Created by Summer Gasaway on 1/2/24.
//

import SwiftUI

struct BookDetailsModalView: View {
    //@Binding var isShowingBookDetails : Bool
    //@Binding var isShowingReader : Bool
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var currentBook: CurrentBook

    var ebook : Ebooks
    
    func setBookDetails(){
        currentBook.bookTitle = ebook.title ?? ""
        currentBook.bookAuthor = ebook.author ?? ""
        currentBook.currentChapter = 1
        currentBook.bookOPFPath = ebook.opfFilePath ?? ""
        currentBook.bookOPFURL = ebook.opfFileURL ?? URL(fileURLWithPath: "/path/to/file.txt")
    }
    
    var body: some View {
        let rowLayout = Array(repeating: GridItem(.fixed(300)), count: 2)
        VStack {
            NavigationStack{
                LazyVGrid(columns: rowLayout, alignment: .center) {
                    AsyncImage(url: URL(fileURLWithPath: ebook.coverImgPath ?? "")){ image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Color.black
                        //replace this with a stand-in image later
                    }
                    VStack{
                        Text(ebook.title ?? "No Title")
                            .font(.largeTitle)
                            .multilineTextAlignment(.leading)
                            .frame(
                                maxWidth: 300
                            )
                        Text(ebook.author ?? "No Author")
                            .font(.title2)
                        ScrollView{
                            Text(ebook.synopsis ?? "No Description")
                                .multilineTextAlignment(.leading)
                                .frame(
                                    maxWidth: 300)
                        }
                    }
                    .aspectRatio(contentMode: .fill)
                    .toolbar{
                        ToolbarItemGroup(placement: .bottomBar){
                            Button {
                                print("Read Button Pressed")
                                setBookDetails()
                                appState.showReaderView = true
                                appState.showBookDetails = false
                                
                            } label: {
                                Text("Read")
                            }

//                            NavigationLink(destination: ReaderView(ebook:ebook))
//                            {
//                                Text("Read")
//                            }
                            
                        }
                        ToolbarItemGroup(placement: .topBarTrailing){
                            Button(action: {
                                print("Edit button pressed")
                            }, label: {
                                Image(systemName: "book.and.wrench")
                            })
                        }
                        ToolbarItemGroup(placement: .topBarLeading){
                            Button(action: {
                                print("Back button pressed")
                                appState.showBookDetails = false
                            }, label: {
                                Image(systemName: "arrowshape.turn.up.backward")
                            })
                        }
                    }
                }
            }
        }
    }
}

// maybe try doing a function here that will get the stupid value and then calling the funciton above?
