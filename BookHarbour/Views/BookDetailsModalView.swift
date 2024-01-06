//
//  BookDetailsModalView.swift
//  BookHarbour
//
//  Created by Summer Gasaway on 1/2/24.
//

import SwiftUI
import CoreData

struct BookDetailsModalView: View {
    //@Binding var isShowingBookDetails : Bool
    //@Binding var isShowingReader : Bool
    //@Environment()
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var currentBook: CurrentBook
    @Environment(\.dismiss) private var dismiss
    
    @State var isEditing : Bool = false
    @State private var hasChanges: Bool = false
    @State private var editedTitle: String = ""
    @State private var editedAuthor: String = ""
    @State private var editedSynopsis: String = ""
    @State private var isImagePickerPresented: Bool = false
    @State private var selectedImage: UIImage?
    @State private var selectedImagePath: String?


    var ebook : Ebooks
    
    func setBookDetails(){
        currentBook.bookTitle = ebook.title ?? ""
        currentBook.bookAuthor = ebook.author ?? ""
        currentBook.currentChapter = 1
        currentBook.bookOPFPath = ebook.opfFilePath ?? ""
        currentBook.bookOPFURL = ebook.opfFileURL ?? URL(fileURLWithPath: "/path/to/file.txt")
    }
    
    func checkChangesThenSave(){
        if DataController.shared.container.viewContext.hasChanges {
            do {
                try DataController.shared.container.viewContext.save()
            } catch {
                print("Error saving managed object context: \(error)")
            }
        }
    }
    
    func loadImage() {
            guard let selectedImage = selectedImage else { return }

            // Save the new image path to ebook.coverImgPath
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let imageFileName = UUID().uuidString
                let imagePath = documentsDirectory.appendingPathComponent(imageFileName)

                if let imageData = selectedImage.jpegData(compressionQuality: 1) {
                    do {
                        try imageData.write(to: imagePath)
                        ebook.coverImgPath = imagePath.path
                        print(ebook.coverImgPath)
                        checkChangesThenSave()
                    } catch {
                        // Handle the error
                        print("Error saving image:", error)
                    }
                }
            }
        }
    
    var body: some View {
        
        let rowLayout = Array(repeating: GridItem(.fixed(300)), count: 2)
        VStack {
            NavigationStack{
                LazyVGrid(columns: rowLayout, alignment: .center) {
//                    if isEditing{
//                        AsyncImage(url: URL(fileURLWithPath: ebook.coverImgPath ?? "")){ image in
//                            image
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                        } placeholder: {
//                            Color.black
//                            //replace this with a stand-in image later
//                        }
//                    }
//                    if !isEditing{
//                        AsyncImage(url: URL(fileURLWithPath: ebook.coverImgPath ?? "")){ image in
//                            image
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                        } placeholder: {
//                            Color.black
//                            //replace this with a stand-in image later
//                        }
//                    }
                    if isEditing {
                        Button(action: {
                            isImagePickerPresented = true
                        }) {
                            AsyncImage(url: URL(fileURLWithPath: selectedImage != nil ? "" : ebook.coverImgPath ?? "")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                Color.black
                                // Replace this with a stand-in image later
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .sheet(isPresented: $isImagePickerPresented, onDismiss: loadImage) {
                            ImagePicker(image: $selectedImage)
                        }
                    } else {
                        AsyncImage(url: URL(fileURLWithPath: selectedImage != nil ? "" : ebook.coverImgPath ?? "")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Color.black
                            // Replace this with a stand-in image later
                        }
                    }
                    
                    VStack{
                        if isEditing{
                            VStack{
                                TextField("\(ebook.title ?? "")", text: $editedTitle)
                                    .font(.largeTitle)
                                    .aspectRatio(contentMode: .fill)
                                //.multilineTextAlignment(.leading)
                                    .frame(
                                        maxWidth: 300
                                    )
                                    .multilineTextAlignment(TextAlignment.center)
                                    .onChange(of: editedTitle) { newValue in
                                            ebook.title = newValue
                                        }
                                TextField("\(ebook.author ?? "")", text: $editedAuthor)
                                    .font(.title2)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(
                                        maxWidth: 300
                                    )
                                    .multilineTextAlignment(TextAlignment.center)
                                    .onChange(of: editedAuthor) { newValue in
                                            ebook.author = newValue
                                        }
                                ScrollView{
                                    TextField("\(ebook.synopsis ?? "")", text: $editedSynopsis, axis: .vertical)
                                        .aspectRatio(contentMode: .fill)
                                        .frame(
                                            maxWidth: 300
                                        )
                                        .multilineTextAlignment(TextAlignment.center)
                                        .onChange(of: editedSynopsis) { newValue in
                                                ebook.synopsis = newValue
                                            }
                                }
                                .border(Color.red)
                            }
                            .border(Color.green)
                        }
                        else if !isEditing{
                                Text(ebook.title ?? "")
                                    .font(.largeTitle)
                                    .multilineTextAlignment(.leading)
                                    .frame(
                                        maxWidth: 300
                                    )
                                Text(ebook.author ?? "")
                                    .font(.title2)
                                    .multilineTextAlignment(.leading)
                            ScrollView{
                                Text(ebook.synopsis ?? "")
                                    .multilineTextAlignment(.leading)
                                    .frame(
                                        maxWidth: 300)
                            }
                        }
                    }
                    .aspectRatio(contentMode: .fill)
                    .toolbar{
                        ToolbarItemGroup(placement: .bottomBar){
                            Button {
                                print("Read Button Pressed")
                                setBookDetails()
                                appState.showReaderView.toggle()
                                //appState.showBookDetails.toggle()
                                dismiss()
                                
                            } label: {
                                Text("Read")
                            }
                        }
                        ToolbarItemGroup(placement: .topBarTrailing){
                            Button(action: {
                                print("Edit button pressed")
                                isEditing.toggle()
                                if editedTitle.isEmpty || editedAuthor.isEmpty || editedSynopsis.isEmpty{
                                    editedTitle = ebook.title ?? ""
                                    editedAuthor = ebook.author ?? ""
                                    editedSynopsis = ebook.synopsis ?? ""
                                }
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
