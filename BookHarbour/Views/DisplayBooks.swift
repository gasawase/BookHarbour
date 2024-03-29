//
//  DisplayBooks.swift
//  BookHarbour
//
//  Created by Summer Gasaway on 1/2/24.
//

import SwiftUI
import CoreData

/// Your view layer consists of DisplayBooks, DefaultView, BookByTagView, and TagRowView. These SwiftUI views are responsible for displaying content to the user. In an MVC context, we aim to keep these views focused on presentation and user interaction, minimizing the business logic contained within.

enum SortingTypes : String, CaseIterable, Identifiable{
    case alphabetic
    case author
    case tags
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
        case .tags:
            return "By Tag"
        }
    }
}
    
struct DisplayBooks: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var currentBook: CurrentBook
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.title)
    ]) var books: FetchedResults <Ebooks>
    @State private var locEbook : Ebooks?

    
    @Binding public var isShowingBookDetails : Bool
    @Binding public var isShowingReader : Bool
    
    @State private var selectedSorting = SortingTypes.alphabetic
    
    /// SORTING BOOKS REQUESTS ///
    @FetchRequest(sortDescriptors: [SortDescriptor(\.title)]) var alphabeticBooks: FetchedResults<Ebooks>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.author)]) var authorBooks: FetchedResults<Ebooks>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.title)]) var tagBooks : FetchedResults<Ebooks>
    
    var sortedBooks: [Ebooks] {
        switch selectedSorting {
        case .alphabetic:
            return Array(alphabeticBooks)
        case .author:
            return Array(authorBooks)
        case .tags:
            return Array(tagBooks)
        }
    }
    
    /// SEARCHING BOOKS REQUESTS ///
    
    @State private var searchText = ""

    var filteredBooks: [Ebooks] {
        if searchText.isEmpty {
            return sortedBooks
        } else {
            return sortedBooks.filter { $0.title!.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    ///

    var body: some View {
        ZStack{
            if selectedSorting != .tags{
                DefaultView(filteredBooks: filteredBooks, isShowingBookDetails: $isShowingBookDetails, isShowingReader: $isShowingReader)
                    .padding(.top, 60)
                    .padding(.bottom, 100)
            }
            else {
                BookByTagView(filteredBooks: filteredBooks, isShowingBookDetails: $isShowingBookDetails, isShowingReader: $isShowingReader)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                // Search bar
                TextField("Search", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .frame(minWidth: 300)
                // drop down menu type
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
//        .padding(.top, 100)
//        .padding(.bottom, 100)
    }
}

struct DefaultView : View {
    var filteredBooks: [Ebooks]

    @State private var locEbook : Ebooks?
    //var epubUrl : String
    //var epubURLs : [URL]
    @State private var newBookList : [Ebooks] = [Ebooks]()
    @State private var isLoading = false
    @State private var selectedSorting = SortingTypes.alphabetic
    //@State var isShowingBookDetails : Bool = false
    @Binding public var isShowingBookDetails : Bool
    @Binding public var isShowingReader : Bool

//    @ObservedObject var ebook : Ebooks
    
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
            // makes the rows
            LazyHGrid(rows: rowLayout, spacing: rowSpacing, content: {
                // makes the columns
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
                        .padding(20)
                    }
                })
            })
        }
        .sheet(isPresented: $isShowingBookDetails) {
            BookDetailsModalView(ebook: $locEbook)
                .zIndex(1)
        }
        //.background(Color("MainBackground"))
    }
}


struct BookByTagView : View {
    var filteredBooks: [Ebooks]
    
    @State private var locEbook : Ebooks?
    
    @Binding public var isShowingBookDetails : Bool
    @Binding public var isShowingReader : Bool
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var allTags: FetchedResults<BookTags>
    
//    @FetchRequest(entity: BookTags.entity(),
//                  sortDescriptors: [NSSortDescriptor(keyPath: \BookTags.bookTagsRelationship, ascending: true)])
//    var bookTagsHere: FetchedResults<BookTags>
    

    
    var body: some View {
        ScrollView{
            VStack{
                ForEach(allTags, id: \.self){ tag in
                    Section {
                        TagRowView(filteredBooks: filteredBooks, currentTag: tag, isShowingBookDetails: $isShowingBookDetails, isShowingReader: $isShowingReader)
                            .background(Color.white.opacity(0.4))
                    } header: {
                        HStack{
                            Text(tag.name ?? "")
                                .font(.title)
                                .padding()
                            Spacer()
                        }
                    }
                }
            }
        }
        .toolbar{
            ToolbarItem {
                Button{
                    DataController.shared.clearAllTags()
                } label: {
                    Text("Clear Tags")
                }
            }
        }
    }
}

struct TagRowView : View{
    var filteredBooks: [Ebooks]
    //var currentTagName: String
    var currentTag : BookTags
    @State private var locEbook : Ebooks?
    
    @Binding public var isShowingBookDetails : Bool
    @Binding public var isShowingReader : Bool
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.title)]) var titleBooks: FetchedResults<Ebooks>
    
    //let fetchRequest: NSFetchRequest<Ebooks> = Ebooks.fetchRequest()
    
    // Assign the predicate to the fetch request
    private func fetchBooksByTag(tag: BookTags) -> [Ebooks] {
        var books: [Ebooks] = []
        
        let context = DataController.shared.container.viewContext
        
        // Create a fetch request for Ebooks entity
        let fetchRequest: NSFetchRequest<Ebooks> = Ebooks.fetchRequest()
        
        // Create a predicate to filter by the specified tag name
        let predicate = NSPredicate(format: "tags CONTAINS[c] %@", tag)
        
        // Assign the predicate to the fetch request
        fetchRequest.predicate = predicate
        
        // Display them by title
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        
        do {
            // Perform the fetch request
            books = try context.fetch(fetchRequest)
            print("This one filters BookTags \(books)")
        } catch {
            print("Error fetching books: \(error.localizedDescription)")
        }
        
        return books
    }
    
    var body: some View{
        let booksByTag = fetchBooksByTag(tag: currentTag)
        
        ScrollView(.horizontal){
            HStack{
                ForEach(booksByTag, id:\.self){ book in
                    // Individual book Details
                    Button {
                        print("\(book.unwrappedTitle) was pressed")
                        locEbook = book
                        isShowingBookDetails.toggle()
                    } label: {
                        IndividualBookRow(isShowingReader: $isShowingReader, ebook: book)
                    }
                    .padding(20)
                }
            }
        }
        .sheet(isPresented: $isShowingBookDetails) {
            BookDetailsModalView(ebook: $locEbook)
                .zIndex(1)
        }
    }
}
    

