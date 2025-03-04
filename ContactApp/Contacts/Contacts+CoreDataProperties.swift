//
//  Contacts+CoreDataProperties.swift
//  ContactApp
//
//  Created by Mayank Jangid on 2/25/25.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var isFavorite: Bool
    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var id: String?

}

extension Contact : Identifiable {

}
