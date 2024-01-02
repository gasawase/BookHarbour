//
//  DisplayBooks.swift
//  BookHarbour
//
//  Created by Summer Gasaway on 1/2/24.
//

import SwiftUI

struct DisplayBooks: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var currentBook: CurrentBook

    @FetchRequest(sortDescriptors: [
            SortDescriptor(\.title)
    ]) var books: FetchedResults <Ebooks>
    //var epubUrl : String
    //var epubURLs : [URL]
    @State private var newBookList : [Ebooks] = [Ebooks]()
    
    let colCount : Int = 4
    let minRowVal : CGFloat = 0
    let maxRowVal : CGFloat = 0
    let rowSpacing : CGFloat = 40
    
    let colMinValue : CGFloat = 0
    let colMaxVal : CGFloat = 180
    let colSpacing : CGFloat = 10
    
    let dataController = DataController.shared
    
    @Binding public var isShowingReader : Bool

    
    // maybe have this somehow linked to a change in the titles?
    func populateBooks(){
        newBookList = dataController.getAllTitles()
    }
    
    var body: some View {
        
        let rowCountEst : Int = colCount
        
        let rowLayout = Array(repeating: GridItem(.fixed(maxRowVal)), count: rowCountEst)
        
        let colLayout = Array(repeating: GridItem(.fixed(colMaxVal)), count: colCount)
        
        
        ScrollView{
            LazyHGrid(rows: rowLayout, spacing: rowSpacing, content: {
                LazyVGrid(columns: colLayout,spacing: colSpacing, content: {
                        ForEach(books, id:\.self){ book in
                            // Individual book Details
                            IndividualBookRow(isShowingReader: $isShowingReader, ebook: book)
                        }
                        .onDelete(perform: { indexSet in
                            indexSet.forEach { index in
                                let bookEntry = books[index]
                                DataController.shared.deleteBookEntry(ebook: bookEntry)
                                populateBooks()
                            }
                        })
                        .padding(20)
                })
            })
        }
        .onAppear(perform: {
            populateBooks()
            print(type(of: books))
        })
        
//        ScrollView{
//            List{
//                ForEach(books, id:\.self){ book in
//                    //Text(book.title ?? "")
//                    // Individual book Details
//                    IndividualBookRow(ebook: book)
//                }
//                .onDelete(perform: { indexSet in
//                    indexSet.forEach { index in
//                        let bookEntry = books[index]
//                        DataController.shared.deleteBookEntry(ebook: bookEntry)
//                        populateBooks()
//                    }
//                })
//
//            }
//            .frame(height: 500)
//            Text(books.count.description)
//        }
//        .onAppear(perform: {
//            populateBooks()
//        })
//        .frame(width:500)
//        .border(Color.red)

    }
    
}
