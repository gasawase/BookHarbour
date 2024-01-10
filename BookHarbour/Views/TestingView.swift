import SwiftUI

class TestingEbook : ObservableObject {
    @Published var title = "Default Title"
    @Published var author = "Default author"
    @Published var synopsis = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent lobortis, massa et tristique sodales, tellus erat iaculis mauris, vitae pulvinar diam urna eu magna. Integer efficitur, lectus eget imperdiet maximus, urna eros faucibus ante, at sodales nulla elit sed urna. Vestibulum tempus ornare lectus at fringilla. Fusce scelerisque et elit ut venenatis. Praesent dapibus dui est, ac placerat sem pretium nec. Maecenas auctor molestie scelerisque. Pellentesque tincidunt lacus sed ex convallis blandit. Donec vestibulum nisl mauris, quis fringilla ante malesuada vitae. Pellentesque vulputate volutpat sapien, et facilisis metus sodales in. Ut laoreet facilisis facilisis. \n Nulla sodales tortor a dictum posuere. Phasellus sit amet magna risus. Fusce non dui ultrices, gravida magna id, venenatis lorem. In interdum et tortor sed viverra. Cras sagittis vehicula viverra. Curabitur commodo nulla ut nisl venenatis convallis. Cras eget sem tempus, fringilla erat sit amet, vehicula metus. Maecenas sed enim at neque pulvinar finibus vel vel purus. Nam ut magna sit amet eros consequat porta. Fusce finibus et turpis non malesuada. Aliquam semper euismod iaculis. Donec nec turpis commodo, volutpat eros ut, viverra neque. Integer quis lacinia nisl. Donec congue purus eget neque fermentum aliquam. Ut iaculis varius lacus."
}


struct TestingBookModalView: View {
    @State var isEditing : Bool = false
    @State var ebook = TestingEbook()
    var body: some View {
        let maxRowLength : CGFloat = 350
        let minRowLength : CGFloat = 100
        let rowLayout = Array(repeating: GridItem(.flexible(minimum: minRowLength, maximum: maxRowLength)), count: 2)
        HStack{
            NavigationStack{
                LazyVGrid(columns: rowLayout, alignment: .center) {
                    AsyncImage(url: URL(string: "https://example.com/icon.png")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Color.black
                        // Replace this with a stand-in image later
                    }
                    //.frame(width: 500, height: 500)
                    VStack{
                        Text(ebook.title)
                            .font(.largeTitle)
                            .multilineTextAlignment(.leading)
                            .frame(
                                maxWidth: 300
                            )
                        Text(ebook.author)
                            .font(.title2)
                            .multilineTextAlignment(.leading)
                        ScrollView{
                            Text(ebook.synopsis)
                                .multilineTextAlignment(.leading)
                                .frame(
                                    maxWidth: 300)
                        }
                    }
                }
                TestingTagView()
                    //.padding(.leading, maxRowLength * 0.878)
                    .frame(width: 800, alignment: .leading)
                .border(Color.green)
                LazyVGrid(columns: rowLayout, alignment: .center) {
                    // Stack for Review information
                }

            }
            .aspectRatio(contentMode: .fill)
            
            
        }
        .toolbar{
            ToolbarItemGroup(placement: .bottomBar){
                Button {
                    print("Read Button Pressed")
                    
                } label: {
                    Text("Read")
                }
            }
            ToolbarItemGroup(placement: .topBarTrailing){
                Button(action: {
                    print("Edit button pressed")
                    isEditing.toggle()
                }, label: {
                    if isEditing{
                        Image(systemName: "square.and.arrow.down")
                    }
                    else {
                        Image(systemName: "book.and.wrench")
                    }
                })
            }
            ToolbarItemGroup(placement: .topBarLeading){
                Button(action: {
                    print("Back button pressed")
                }, label: {
                    Image(systemName: "arrowshape.turn.up.backward")
                })
            }
        }
    }
}

struct TestingTagView : View{
    @State var arrTags : [BookTags] = []
    @State var tempArr : [String] = ["First Tag", "Second Tag", "Third Tag", "Fourth Tag", "Fifth Tag", "Sixth Tag", "Seventh Tag"]
    @EnvironmentObject var currentBook: CurrentBook
    @StateObject private var viewModel = BookTagsViewModel()
    @State private var newTagName: String = ""
    @State var addTagPressed : Bool = false
    @State var enterPressed : Bool = false
    
    let bookUID = UUID(uuidString: "testing")
    let tagColumns = Array(repeating: GridItem(.flexible(minimum: 10, maximum: .infinity)), count: 2)
    var body : some View{
        HStack{
            // Add Button
            Button(action: {
                print("add tag button pressed")
                addTagPressed.toggle()
            }, label: {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(Color.blue)
                    .padding()
            })
            if addTagPressed{
                HStack {
                    TextField("Enter tag name", text: $newTagName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            enterPressed.toggle()
                            print("enter pressed")
                            // add to core data here
                            tempArr.append(newTagName)
                            newTagName = ""
                        }
                }
            }
                LazyHGrid(rows: tagColumns, spacing: 20) {
                        ForEach(tempArr, id: \.self) { tag in
                            Text(tag)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.blue)
                                )
                                .foregroundColor(.white)
                        }
                    }
                .border(Color.red)
            
            //}
        }
    }
}

//struct TestingDisplayBooks:View{
//    var body: some View {
//        
//    }
//}
//
//struct TestingIndividualBookRow:View {
//    var body: some View {
//        
//    }
//}
//
//struct TestingReadingView:View {
//    var body: some View {
//
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TestingBookModalView()
    }
}
