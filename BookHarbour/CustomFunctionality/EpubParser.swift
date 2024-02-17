//
//  EpubParser.swift
//  BookHarbour
//
//  Created by Summer Gasaway on 1/2/24.
//

import Foundation
import SWXMLHash
import SwiftSoup
import CoreData

enum BookAttribute {
    case title
    case author
    case epubURL
}

class EpubParser: NSObject, XMLParserDelegate{
    private var manifestItems: [String: String] = [:]
    //private var metaInfo: [String: String] = [:] //NOT Metadata
    private var metadata : [String:String] = [:]
    private var spineItems: [String] = []
    private var currentElement: String = ""
    private var currentAttributes: [String: String] = [:]
    private var opfFilePath: String = ""
    private var unzipDirectory: URL!
    private var itemCoverVal : String = "" // is either cover or cover-id
    private var metaCoverVal : String = "" // is either cover or cover-id
    private var metaContentVal : String = ""
    
    private var coverImagePath : String = ""
    private var metadataObj : XMLBasicMetadata = XMLBasicMetadata(title: "", author: "", synopsis: "")
    private var opfDataObj : XMLOPFData!
    //private var ncxDataObj : XMLNCXData!
    private var ncxDict : [String:String] = [:]
    private var coverURL : String = ""
    
    init(epubDirectory: URL){
        self.unzipDirectory = epubDirectory
    }
    
//    func parseEpub(completion: @escaping (URL?) -> Void) {
//        let containerXMLPath = unzipDirectory.appendingPathComponent("META-INF/container.xml").path
//        if let containerXMLData = FileManager.default.contents(atPath: containerXMLPath) {
//            // this is where the xml container data is stored
//            let xml = XMLHash.lazy(containerXMLData)
//            // this gets the rootfilepath of the opf
//            if let rootfilePath = xml["container"]["rootfiles"]["rootfile"].element?.attribute(by: "full-path")?.text {
//                // and if it's valid, it says to get the opfURL from the unzipDirectory (where the epub was unzipped to)
//                let opfURL = unzipDirectory.appendingPathComponent(rootfilePath)
//                let parentFilePath = opfURL.deletingLastPathComponent()
//                parseOPFFile(opfURL, completion: completion)
//                parseNCXFile(parentFilePath.path(), completion: completion)
//            }
//        }
//    }
    
    func parseEpub(completion: @escaping (URL?) -> Void) {
        let containerXMLPath = unzipDirectory.appendingPathComponent("META-INF/container.xml").path
        guard let containerXMLData = FileManager.default.contents(atPath: containerXMLPath) else {
            completion(nil)
            return
        }

        let xml = XMLHash.lazy(containerXMLData)
        if let rootfilePath = xml["container"]["rootfiles"]["rootfile"].element?.attribute(by: "full-path")?.text {
            do {
                let opfURL = try unzipDirectory.appendingPathComponent(rootfilePath)
                let parentFilePath = opfURL.deletingLastPathComponent()
                parseOPFFile(opfURL, completion: completion)
                //parseNCXFile(parentFilePath.path(), completion: completion)
            } catch {
                completion(nil)
            }
        }
    }
    
    private func parseOPFFile(_ opfURL: URL, completion: @escaping (URL?) -> Void) {
        do {
            guard let containerOPFXMLData = FileManager.default.contents(atPath: opfURL.path()) else {
                completion(nil)
                return
            }

            let opfXML = XMLHash.lazy(containerOPFXMLData)
            let opfParser = XMLParser(contentsOf: opfURL)
            opfParser?.delegate = self
            opfParser?.parse()

            opfDataObj = try opfXML["package"].value()
            if opfDataObj != nil {
                metadataObj = try opfDataObj.metadata.value()
                coverURL = getCoverURL(manifestItems: manifestItems, opfURL: opfURL)
                addToCoreData(opfURL: opfURL, metadata: metadataObj, manifestItems: manifestItems, epubPath: unzipDirectory, coverURL: coverURL)
            } else {
                print("opfDataObj is nil; \(opfURL) is where it came from")
                completion(nil)
                return
            }

        } catch {
            // Handle the error here
            print("An error occurred: \(error); \(opfURL) is where it came from")
            completion(nil)
        }
    }
    
//    func parseNCXFile(_ parentFilePath: String, completion: @escaping (URL?) -> Void) {
//        // ncx file is XML
//        // navPoints are in an array
//        // ncx[navMap][navPoint][navLabel]
//        // ncx[navMap][navPoint][content]
//        
//        let ncxFilePath = parentFilePath.appending("toc.ncx")
//        let ncxURL = URL(string: ncxFilePath)!
//        //if let containerNCXXMLData = FileManager.default.contents(atPath: ncxFilePath)
//        if let containerNCXXMLData = FileManager.default.contents(atPath: ncxURL.path())
//        {
//            let ncxData = XMLHash.lazy(containerNCXXMLData)
////            if let ncxParser = XMLParser(contentsOf: ncxURL){
////                ncxParser.delegate = self
////                ncxParser.parse()
////            }
////            else{
////                completion(nil)
////            }
//            do{
//                ncxDataObj = try ncxData["ncx"].value()
//                let navPoints = ncxData["ncx"]["navMap"]["navPoint"].all
//                for navPoint in navPoints {
//                    if let label = navPoint["navLabel"]["text"].element?.text, let content = navPoint["content"].element?.attribute(by: "src")?.text {
//                        ncxDict[label] = content
//                        //print("Label: \(label ), Content: \(content )")
//                    }
//                }
//                //print(ncxDict)
//
//            } catch {
//                print("An error occured: \(error)")
//            }
//        }
//    }
    
//    struct XMLNCXData : XMLObjectDeserialization{
//        let navMap : XMLIndexer
//        let navPoint : XMLIndexer
//        let navLabel : XMLIndexer
//        
//        static func deserialize(_ element: XMLIndexer) throws -> XMLNCXData {
//            return try XMLNCXData(
//            navMap: element["navMap"],
//            navPoint: element["navMap"]["navPoint"],
//            navLabel: element["navMap"]["navPoint"]["navLabel"]
//            )
//        }
//    }
    
    // Implement XMLParserDelegate methods
    // can probably implement a switch/case for better efficiency later
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        switch elementName {
        case "item":
            if let itemId = attributeDict["id"], let href = attributeDict["href"] {
                manifestItems[itemId] = href
            }

        case "itemref":
            if let idref = attributeDict["idref"] {
                spineItems.append(idref)
            }
        case "meta":
            if let metaName = attributeDict["name"]?.lowercased(), let metaContent = attributeDict["content"], (metaName == "cover" || metaName == "cover-image" || metaName == "coverimg" || metaName == "coverimage" || metaName == "cover-img"), let metaCover = attributeDict["content"] {
                metaCoverVal = metaCover
                metaContentVal = metaContent            }
        case "navPoint":
            print("NavPoint detected, my liege.")
        default:
            break
        }
    }
    
    func addToCoreData(opfURL: URL, metadata: XMLBasicMetadata, manifestItems: [String:String], epubPath: URL, coverURL: String) {
        // Check if a book with the same title already exists
        let fetchRequest: NSFetchRequest<Ebooks> = Ebooks.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@ AND author == %@", metadata.title, metadata.author)

        do {
            let existingBooks = try DataController.shared.container.viewContext.fetch(fetchRequest)
            
            // If a book with the same title already exists, don't save the duplicate
            if let existingBook = existingBooks.first {
                print("Duplicate book found with title: \(existingBook.title ?? ""), author: \(existingBook.author ?? "")")
                return
            }
            
            let newBook = Ebooks(context: DataController.shared.container.viewContext)
            newBook.id = UUID()
            newBook.title = metadata.title
            newBook.author = metadata.author
            newBook.coverImgPath = coverURL
            newBook.opfFilePath = opfURL.path()
            newBook.opfFileURL = opfURL
            newBook.epubPath = epubPath.path()
            newBook.synopsis = metadata.synopsis

            try DataController.shared.container.viewContext.save()
        } catch let error as NSError {
            print("Error saving to CoreData: \(error.localizedDescription)")
        }
    }
    
    func getCoverURL(manifestItems: [String:String], opfURL: URL) -> String{
        if let coverHref = manifestItems[metaContentVal], coverHref.hasSuffix(".jpg") || coverHref.hasSuffix(".jpeg") || coverHref.hasSuffix(".png"){
            coverImagePath = coverHref
        }
        
        //let parentURL = opfURL
        let parentFilePath = opfURL.deletingLastPathComponent()
        let finalCoverURLPath = parentFilePath.appending(path: coverImagePath).path()
        
        return finalCoverURLPath
        
    }
}

struct XMLOPFData: XMLObjectDeserialization{
    let manifest : XMLIndexer
    let metadata : XMLIndexer
    let spine : XMLIndexer
    
    static func deserialize(_ element: XMLIndexer) throws -> XMLOPFData {
        return try XMLOPFData(
            manifest: element["manifest"],
            metadata: element["metadata"],
            spine: element["spine"]
        )
    }
}

struct XMLBasicMetadata : XMLObjectDeserialization{
    let title : String
    let author : String
    let synopsis : String
    //let language : String
    //let datePublished : String
    
    static func deserialize(_ element: XMLIndexer) throws -> XMLBasicMetadata {
        let dcDescription: String? = try? element["dc:description"].value()
        let description: String? = try? element["description"].value()
        
        let synopsisValue = dcDescription ?? description ?? "Description not found"
        
        let dcCreator: String? = try? element["dc:creator"].value()
        let creator: String? = try? element["creator"].value()
        let creatorValue = dcCreator ?? creator ?? "Author Not Found"

        return try XMLBasicMetadata(
            title: element["dc:title"].value() ?? "Title not found",
            author: creatorValue,
            synopsis: synopsisValue
//            language: element["dc:language"].value() ?? "Language not found",
//            datePublished: element["dc:date"].value() ?? "Original Published Date not found",
//            publisher: element["dc:publisher"].value() ?? "Publisher information not found",
//
        )
    }
}


class OPFTryGetData : NSObject, XMLParserDelegate{
    private var metadataObj : XMLBasicMetadata!
    private var opfDataObj : XMLOPFData!
    private var manifestItems: [String: String] = [:]
    private var spineItems: [String] = []
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        switch elementName {
        case "item":
            if let itemId = attributeDict["id"], let href = attributeDict["href"] {
                manifestItems[itemId] = href
            }
        case "itemref":
            if let idref = attributeDict["idref"] {
                spineItems.append(idref)
            }
        default:
            break
        }
    }
    
    public func getSpineItems(_ opfURL:URL) -> [String]{
        if FileManager.default.contents(atPath: opfURL.path()) != nil{
//            let opfXML = XMLHash.lazy(containerOPFXMLData)
            if let opfParser = XMLParser(contentsOf: opfURL)
            {
                opfParser.delegate = self
                opfParser.parse()
            }
        }
        return spineItems
    }
    public func getManifestItems(_ opfURL:URL) -> [String:String]{
        if let containerOPFXMLData = FileManager.default.contents(atPath: opfURL.path()){
//            let opfXML = XMLHash.lazy(containerOPFXMLData)
            if let opfParser = XMLParser(contentsOf: opfURL)
            {
                opfParser.delegate = self
                opfParser.parse()
            }
             
        }
        return manifestItems
    }
    
}
