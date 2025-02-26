//
//  Contacts+CoreDataProperties.swift
//  ContactApp
//
//  Created by Mayank Jangid on 2/25/25.
//
//

import Foundation
import CoreData


extension Contacts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contacts> {
        return NSFetchRequest<Contacts>(entityName: "Contacts")
    }

    @NSManaged public var isFavorite: Bool
    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?

}

extension Contacts : Identifiable {

}
