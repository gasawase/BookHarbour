//
//  FileSelectorController.swift
//  BookHarbour
//
//  Created by Summer Gasaway on 1/2/24.
//

import Foundation
import SwiftUI

class FileSelectorController : ObservableObject{
    // get the controller for reading the epubs
    @Published var folderURL: URL?
    @Published var epubFiles: [URL] = []
    @Published var currentEpubIndex: Int = 0
    
//    var bookBinder : Bookbinder
    

    //@Environment(\.managedObjectContext) var moc
    
    // somehow make an initializer?
    
    func loadEpubFiles(from folderURL: URL) {
        // only loops once
        do {
            let files = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
            epubFiles = files.filter { $0.pathExtension.lowercased() == "epub" }
            // call the function to read the epubs here
            // for each epub, have it get the information and write it to the database
            // for now, just have it print the title
            
            for epubFile in epubFiles {
                // currentEpubIndex += 1
                // this now binds the bookBinder information at this epubFile location
                
                
                
                //var ebook = bookBinder.bindBook(at: epubFile)
                // sometimes getting an error of encoding mismatch and i don't know why
                /// 1) tried just printing the file names and they're all the same except for the name so it's probably not that
                /// 2) also getting the error that the file doesn't exist when it does
            
//                let containerURL = epubFile.appendingPathComponent("META-INF/container.xml")
//                let data = try Data(contentsOf: containerURL)
//                print("Data: \(data)")
                
                let fileManager = FileManager()
                //let ebook = bookBinder.bindBook(at: epubFile)

                let unzipHelper = UnzipHelper.self
                unzipHelper.unzipEPUB(epubURL: epubFile) { [weak self] unzipDirectory in
                    guard let self = self, let unzipDirectory = unzipDirectory else {
                        print("error unzipping epub")
                        return
                    }
                    //print("epub unzipDirectory: \(unzipDirectory)")
                    let epubParser = EpubParser(epubDirectory: unzipDirectory)
                    epubParser.parseEpub() { result in
                        //print("Parsing completed with result: \(result?.path ?? "No result")")
                    }
                }
                
//                let document = try Kanna.XML(xml: data, encoding: .utf8)
//                print(document)
                //let ebook = bookBinder.bindBook(at: epubFile)
                
//                let title = ebook?.opf.metadata.titles.first ?? "No Title"
//
//                let author = ebook?.opf.metadata.creators.first ?? "No Author"
//                let descr = ebook?.opf.metadata.description ?? "No Description"
//                let coverImgId = ebook?.coverImageURLs.first?.absoluteString
//
//                //saving book to Database EDIT: can't do this outside of a view
//                let newBook = Ebooks(context: DataController.shared.container.viewContext)
//                    newBook.id = UUID()
//                    newBook.title = title
//                    newBook.author = author
//                    newBook.synopsis = descr
//                    newBook.epubURL = epubFile.absoluteString
//                    newBook.coverImgURL = coverImgId ?? ""
//                    newBook.tempFileURL = epubFile
//
//
//                try? DataController.shared.container.viewContext.save()
                //print(currentEpubIndex)
                                
            }
            
        } catch {
            print("Error loading ePub files: \(error)")
        }
    }
    
//    func testXHTMLReader(ebookURL : URL){
//        let bookBinder = Bookbinder()
//
//        let ebook = bookBinder.bindBook(at: ebookURL)
//        let pages = ebook?.pages ?? []
//        let tocFromSpine = ebook?.ncx?.points
//
//        for page in pages{
//            print("Pages: \(page)")
//        }
//        print("TOCFromSpine: \(tocFromSpine)")
//    }
    
}
