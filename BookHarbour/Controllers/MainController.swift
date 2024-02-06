//
//  MainController.swift
//  BookHarbour
//
//  Created by Summer Gasaway on 1/2/24.
//

import Foundation
class MainController: ObservableObject{
    let dataController = DataController.shared
    
}

enum BookHarbourErrorType : Error{
    case titleNil
    case authorNil
    case missingOPFPath
    case missingOPFURL
    case missingUID
    case missingInfo(String)
}

class AppState: ObservableObject {
    @Published var showBookDetails: Bool = false
    @Published var showReaderView: Bool = false
    @Published var showTestingView: Bool = false
}

class CurrentBook: ObservableObject {
    @Published var bookTitle : String = ""
    @Published var bookAuthor : String = ""
    @Published var currentChapter : Int = 1
    @Published var bookOPFPath : String = ""
    @Published var bookOPFURL : URL = URL(fileURLWithPath: "/path/to/file.txt")
    @Published var bookUID : UUID = UUID()
    // current location
    
}

class NumOfBooks : ObservableObject {
    @Published var numOFBooks : Int = 0
}

extension Optional {
    func unwrap( variableName: String) throws -> Wrapped {
        guard let unwrapped = self else {
            throw BookHarbourErrorType.missingInfo("\(variableName) is missing")
        }
        return unwrapped
    }
}

extension String {
    func attributedStringFromHTML() -> NSAttributedString {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
}
