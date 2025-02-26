//
//  ContactManager.swift
//  ContactApp
//
//  Created by Mayank Jangid on 2/26/25.
//

import CoreData
import UIKit

class ContactsManager {
    static let shared = ContactsManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func fetchContacts() -> [Contact] {
        let request: NSFetchRequest<Contact> = Contact.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch contacts: \(error.localizedDescription)")
            return []
        }
    }
}
