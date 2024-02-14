//
//  DisplayBooks.swift
//  BookHarbour
//
//  Created by Summer Gasaway on 1/2/24.
//

import SwiftUI

enum SortingTypes : String, CaseIterable, Identifiable{
    case alphabetic
    case author
    //    case tags
    //    case longestShortest
    //    case shortestLongest
    //    case readUnread
    //    case unreadRead
    var id: Self { return self }
    var title: String {
        switch self {
        case .alphabetic:
            return "Alpha"
        case .author:
            return "Author"
            //                case .tags:
            //                    return "By Tag"
            //            }
        }
    }
}
    
struct DisplayBooks: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var currentBook: CurrentBook
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.title)
    ]) var books: FetchedResults <Ebooks>
    
    //var epubUrl : String
    //var epubURLs : [URL]
    @State private var newBookList : [Ebooks] = [Ebooks]()
    @State private var isLoading = false
    @State private var selectedSorting = SortingTypes.alphabetic
    @State private var locEbook : Ebooks?
    //@State var isShowingBookDetails : Bool = false
    @Binding public var isShowingBookDetails : Bool
    @Binding public var isShowingReader : Bool

//    @ObservedObject var ebook : Ebooks

    /// SORTING BOOKS REQUESTS ///
    @FetchRequest(sortDescriptors: [SortDescriptor(\.title)]) var alphabeticBooks: FetchedResults<Ebooks>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.author)]) var authorBooks: FetchedResults<Ebooks>
    //    @FetchRequest(sortDescriptors: [SortDescriptor(\.title)]) var tagBooks : FetchedResults<Ebooks>
    
    /// SEARCHING BOOKS REQUESTS ///
    
    @State private var searchText = ""

    var filteredBooks: [Ebooks] {
        if searchText.isEmpty {
            return sortedBooks
        } else {
            return sortedBooks.filter { $0.title!.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var sortedBooks: [Ebooks] {
        switch selectedSorting {
        case .alphabetic:
            return Array(alphabeticBooks)
        case .author:
            return Array(authorBooks)
//        case .tags:
//            return Array(tagBooks)
        }
    }
    
    let colCount : Int = 4
    let minRowVal : CGFloat = 0
    let maxRowVal : CGFloat = 0
    let rowSpacing : CGFloat = 40
    
    let colMinValue : CGFloat = 0
    let colMaxVal : CGFloat = 180
    let colSpacing : CGFloat = 10
    
    let dataController = DataController.shared
    
    var body: some View {
        
        let rowCountEst : Int = colCount
        
        let rowLayout = Array(repeating: GridItem(.fixed(maxRowVal)), count: rowCountEst)
        
        let colLayout = Array(repeating: GridItem(.fixed(colMaxVal)), count: colCount)
        
        
        ScrollView{
            LazyHGrid(rows: rowLayout, spacing: rowSpacing, content: {
                LazyVGrid(columns: colLayout,spacing: colSpacing, content: {
                    
                    ForEach(filteredBooks, id:\.self){ book in
                        // Individual book Details
                        Button {
                            print("\(book.unwrappedTitle) was pressed")
                            locEbook = book
                            isShowingBookDetails.toggle()
                        } label: {
                            IndividualBookRow(isShowingReader: $isShowingReader, ebook: book)
                        }
                    }
                    .padding(20)
                })
            })
        }
        .sheet(isPresented: $isShowingBookDetails) {
            BookDetailsModalView(ebook: $locEbook)
                .zIndex(1)
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                // Search bar
                TextField("Search", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .frame(minWidth: 300)
                Picker("Sort",selection: $selectedSorting) {
                    ForEach(SortingTypes.allCases, id: \.self)
                    {
                        Text($0.title)
                            .tag($0)
                    }
                }
                .pickerStyle(.menu)
            }
        }
        .background(Color("MainBackground"))
    }
}


