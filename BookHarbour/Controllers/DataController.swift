//
//  DataController.swift
//  BookHarbour
//
//  Created by Summer Gasaway on 1/2/24.
//

import Foundation
import CoreData

struct DataController{
    static let shared = DataController()
    
    let container: NSPersistentContainer
    
    // A test configuration for SwiftUI previews
    static var preview: DataController = {
        let controller = DataController(inMemory: true)

        // Create 10 example programming languages.
        for _ in 0..<10 {
            let testBook = Ebooks(context: controller.container.viewContext)
            testBook.id = UUID()
            testBook.title = "Testing Title"
            testBook.author = "Testing Author"
        }
        
            //get the files in here
        
        return controller
    }()
    
    // An initializer to load Core Data, optionally able
    // to use an in-memory store.
    init(inMemory: Bool = false) {
        // If you didn't name your model Main you'll need
        // to change this name below.
        container = NSPersistentContainer(name: "Library")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func save(){
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
                print("saved")
            } catch {
                print("Could not save")
            }
        }
    }
    

    
    func deleteBookEntry(ebook: Ebooks){
        container.viewContext.delete(ebook)
        do{
            try container.viewContext.save()
        } catch{
            container.viewContext.rollback()
            print("Failed to save context \(error)")
        }
    }
    
    func getAllTitles() -> [Ebooks]{
        let fetchRequest : NSFetchRequest<Ebooks> = Ebooks.fetchRequest()
        do{
            return try container.viewContext.fetch(fetchRequest)
        } catch{
            return[]
        }
    }
    
    func clearAllTitles(){
        var allTitles = getAllTitles()
        
        for book in allTitles{
            deleteBookEntry(ebook: book)
        }
    }
    
    // try taking in a book value and then testing that and testing all of those values instead of being super specific
}

class BookTagsViewModel: ObservableObject {
    @Published var bookTags: [BookTags] = []
    
    func fetchBookTags(forBookUID bookUID: UUID) {
        //let toString = String(describing: bookUID)
        // Perform your CoreData fetch request here
        // Example:
        let fetchRequest: NSFetchRequest<BookTags> = BookTags.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "bookUID == %@", bookUID as CVarArg)
        
        do {
            let fetchedResults = try DataController.shared.container.viewContext.fetch(fetchRequest)
            for entity in fetchedResults {
                // Process the fetched entities
                //print(entity)
            }
        } catch {
            // Handle fetch errors
            print("Error fetching data: \(error.localizedDescription)")
        }
        
//        do {
//            self.bookTags = try DataController.shared.container.viewContext.fetch(fetchRequest)
//        } catch {
//            // Handle error
//            print("Error fetching data: \(error.localizedDescription)")
//        }
    }
    
    func addTag(forBookUID bookUID: UUID, tagName: String) {
        // Create a new tag and save it to CoreData
        let newTag = BookTags(context: DataController.shared.container.viewContext)
            newTag.name = tagName
        DataController.shared.container.viewContext.insert(newTag)
        
        do {
            try DataController.shared.container.viewContext.save()
            // Update the local array
            self.bookTags.append(newTag)
        } catch {
            // Handle error
            print("Error saving data: \(error.localizedDescription)")
        }
    }
}
