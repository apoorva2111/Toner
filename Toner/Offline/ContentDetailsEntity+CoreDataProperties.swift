//
//  ContentDetailsEntity+CoreDataProperties.swift
//  
//
//  Created by User on 28/10/20.
//
//

import Foundation
import CoreData


extension ContentDetailsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContentDetailsEntity> {
        return NSFetchRequest<ContentDetailsEntity>(entityName: "ContentDetailsEntity")
    }

    @NSManaged public var artistImage: String?
    @NSManaged public var artistName: String?
    @NSManaged public var fileSize: String?
    @NSManaged public var fileType: String?
    @NSManaged public var songDuration: String?
    @NSManaged public var songID: String?
    @NSManaged public var songImage: String?
    @NSManaged public var songName: String?
    @NSManaged public var songPath: String?

}
