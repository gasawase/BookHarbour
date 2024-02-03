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
    

    func loadEpubFiles(from folderURL: URL) {
        // only loops once
        do {
            let files = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
            epubFiles = files.filter { $0.pathExtension.lowercased() == "epub" }
            // call the function to read the epubs here
            // for each epub, have it get the information and write it to the database
            // for now, just have it print the title
            for epubFile in epubFiles {
                let unzipHelper = UnzipHelper.self
                unzipHelper.unzipEPUB(epubURL: epubFile) { [weak self] unzipDirectory in
                    guard let self = self, let unzipDirectory = unzipDirectory else {
                        print("error unzipping epub")
                        return
                    }
                    let epubParser = EpubParser(epubDirectory: unzipDirectory)
                    epubParser.parseEpub() { result in
                    }
                }
            }
            
        } catch {
            print("Error loading ePub files: \(error)")
        }
    }
}
