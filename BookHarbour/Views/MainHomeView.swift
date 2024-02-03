//
//  MainHomeView.swift
//  BookHarbour
//
//  Created by Summer Gasaway on 1/2/24.
//

import SwiftUI

struct MainHomeView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext

    @EnvironmentObject var appState: AppState

    @State private var isModalPresented = false
    @State private var isFilePickerPresented = false
    @State private var selectedFolderURL: URL?
    
    @State public var isShowingReader : Bool = false
    @State public var isShowingBookDetails : Bool = false

        
    var fileHaveBeenSelected = false
    
    var body: some View {
        
        HoldingView(isShowingReader: $isShowingReader, isShowingBookDetails: $isShowingBookDetails)
    }
}

struct HoldingView : View{
    @Environment (\.dismiss) private var dismiss

    
    @Binding public var isShowingReader : Bool
    @Binding public var isShowingBookDetails : Bool
    var body: some View {
        NavigationSplitView {
            NavBarView()
        } detail: {
            ZStack{
                Color("MainBackground").ignoresSafeArea(.all)
                DisplayBooks(isShowingBookDetails: $isShowingBookDetails, isShowingReader: $isShowingReader)

            }

            // this \/ only fills the middle column of the screen -_-
                //.background(Color.green, ignoresSafeAreaEdges: .all)
        }
        .background(Color("MainBackground")).ignoresSafeArea(.all)
        
    }
}

struct NavBarView : View{
    @StateObject var fileSelectorController = FileSelectorController()
    @State private var isFilePickerPresented = false
    @State private var selectedFolderURL: URL?
    @State private var fileLocArr : [String] = []

    
    let dataController = DataController.shared
    
    
    var body : some View{
        NavigationStack{
            VStack{
                if fileLocArr.isEmpty{
                    Text("No folder selected")
                }
                else{
                    List{
                        ForEach(fileLocArr, id:\.self) { fileLoc in
                            Text(fileLoc)
                        }
                    }
                }
            }
            .toolbar{
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button {
                        print("Select a folder clicked")
                        isFilePickerPresented = true
                        // close the navigation stack
                    } label: {
                        Text("Select a Folder...")
                    }
                    Button {
                        print("reset books clicked")
                        dataController.clearAllTitles()
                        fileLocArr.removeAll()
                    } label: {
                        Text("Reset Books")
                    }
                }
            }
            .padding()
            .fileImporter(isPresented: $isFilePickerPresented, allowedContentTypes: [.folder], allowsMultipleSelection: false) { result in
                do {
                    guard let selectedURL = try result.get().first else { return }
                    selectedFolderURL = selectedURL
                    fileLocArr.append(selectedFolderURL?.absoluteString ?? "")
                    guard selectedURL.startAccessingSecurityScopedResource() else { // Notice this line right here
                        return
                    }
//                    try FileManager.default.contentsOfDirectory(at: selectedURL, includingPropertiesForKeys: nil)
//                    fileSelectorController.loadEpubFiles(from: selectedURL)

                        do {
                            try FileManager.default.contentsOfDirectory(at: selectedURL, includingPropertiesForKeys: nil)
                            fileSelectorController.loadEpubFiles(from: selectedURL)
                        } catch {
                            print("File picking error:", error.localizedDescription)
                        }

                    } catch {
                    print("File picking error:", error.localizedDescription)
                }
            }
        }
    }
}

