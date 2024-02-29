//
//  Ebooks+CoreDataProperties.swift
//  
//
//  Created by Summer Gasaway on 2/14/24.
//
//

import Foundation
import CoreData


extension Ebooks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ebooks> {
        return NSFetchRequest<Ebooks>(entityName: "Ebooks")
    }

    @NSManaged public var author: String?
    @NSManaged public var bookUID: UUID?
    @NSManaged public var coverImgPath: String?
    @NSManaged public var currReadLoc: Int32
    @NSManaged public var epubPath: String?
    @NSManaged public var id: UUID?
    @NSManaged public var opfFilePath: String?
    @NSManaged public var opfFileURL: URL?
    @NSManaged public var synopsis: String?
    @NSManaged public var timeRead: Int32
    @NSManaged public var title: String?
    @NSManaged public var genre: String?
    @NSManaged public var reviewLink: NSSet?
    @NSManaged public var tags: NSSet?
    
    public var unwrappedTitle : String{ title ?? "No Title" }
    public var unwrappedAuthor : String{ author ?? "No Author" }

}

// MARK: Generated accessors for reviewLink
extension Ebooks {

    @objc(addReviewLinkObject:)
    @NSManaged public func addToReviewLink(_ value: Reviews)

    @objc(removeReviewLinkObject:)
    @NSManaged public func removeFromReviewLink(_ value: Reviews)

    @objc(addReviewLink:)
    @NSManaged public func addToReviewLink(_ values: NSSet)

    @objc(removeReviewLink:)
    @NSManaged public func removeFromReviewLink(_ values: NSSet)

}


// MARK: Generated accessors for tags
extension Ebooks {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: BookTags)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: BookTags)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}
