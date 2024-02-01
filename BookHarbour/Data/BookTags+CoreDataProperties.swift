//
//  BookTags+CoreDataProperties.swift
//  
//
//  Created by Summer Gasaway on 1/31/24.
//
//

import Foundation
import CoreData


extension BookTags {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookTags> {
        return NSFetchRequest<BookTags>(entityName: "BookTags")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var bookTagsRelationship: NSSet?

}

// MARK: Generated accessors for bookTagsRelationship
extension BookTags {

    @objc(addBookTagsRelationshipObject:)
    @NSManaged public func addToBookTagsRelationship(_ value: Ebooks)

    @objc(removeBookTagsRelationshipObject:)
    @NSManaged public func removeFromBookTagsRelationship(_ value: Ebooks)

    @objc(addBookTagsRelationship:)
    @NSManaged public func addToBookTagsRelationship(_ values: NSSet)

    @objc(removeBookTagsRelationship:)
    @NSManaged public func removeFromBookTagsRelationship(_ values: NSSet)

}
