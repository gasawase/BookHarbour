//
//  Reviews+CoreDataProperties.swift
//  
//
//  Created by Summer Gasaway on 1/31/24.
//
//

import Foundation
import CoreData


extension Reviews {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reviews> {
        return NSFetchRequest<Reviews>(entityName: "Reviews")
    }

    @NSManaged public var reviewTitle : String?
    @NSManaged public var reviewContent: String?
    @NSManaged public var reviewDateStarted: String?
    @NSManaged public var reviewDateFinished: String?
//    @NSManaged public var reviewTotalTime: Date?
//    @NSManaged public var reviewRating: Int?
    
    @NSManaged public var reviewToBook: Ebooks?

}
