//
//  UnzipHelper.swift
//  BookHarbour
//
//  Created by Summer Gasaway on 1/2/24.
//

import Foundation
import SSZipArchive

class UnzipHelper{
    static func unzipEPUB(epubURL: URL, completion: @escaping (URL?) -> Void) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let epubName = (epubURL.lastPathComponent as NSString).deletingPathExtension
        let unzipDirectory = documentsDirectory.appendingPathComponent(epubName)
        
        // Unzip the EPUB file
        do {
            try SSZipArchive.unzipFile(atPath: epubURL.path, toDestination: unzipDirectory.path, overwrite: true, password: nil)
            print("EPUB Unzipped successfully.")
            completion(unzipDirectory)
        } catch {
            print("Error unzipping file: \(error)")
            completion(nil)
        }
    }
}
