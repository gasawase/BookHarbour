import SwiftUI
import CoreData

// Step 1: CoreData model for "BookTags"
//struct BookTags: Identifiable {
//    let id = UUID()
//    let bookUID: String
//    // Add other properties as needed
//}

// Step 2: ViewModel for data fetching
class BooksTagViewModel: ObservableObject {
    @Published var bookTags: [BookTags] = []
    
    func fetchBookTags(forBookUID bookUID: UUID) {
        // Perform your CoreData fetch request here
        // Example:
        let fetchRequest: NSFetchRequest<BookTags> = BookTags.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "bookUID == %@", bookUID as CVarArg)
        
        do {
            self.bookTags = try DataController.shared.container.viewContext.fetch(fetchRequest)
        } catch {
            // Handle error
            print("Error fetching data: \(error.localizedDescription)")
        }
    }
}

// Step 3: SwiftUI View
struct TestingView: View {
    @StateObject private var viewModel = BooksTagViewModel()
    let bookUID = UUID(uuidString: "testing") // Replace with the actual UID
    @FetchRequest(sortDescriptors: [
            SortDescriptor(\.name)
    ]) var bookTags: FetchedResults <BookTags>
    var body: some View {
        ForEach(bookTags, id:\.self){ tag in
            Text(tag.name ?? "")
        }
//        List(viewModel.bookTags) { bookTag in
//            
//
//            // Display your fetched data in the list
//            Text(bookTag.bookUID.unwrap(variableName: "UUID"))
//            // Add other views as needed
//        }
//        .onAppear {
//            // Trigger the fetch request when the view appears
//            //viewModel.fetchBookTags(forBookUID: bookUID.unwrap(variableName: "UUID"))
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TestingView()
    }
}
