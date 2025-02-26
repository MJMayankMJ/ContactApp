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
    
    private init() {}
    
    // MARK: - Core Data Context
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // MARK: - Save a New Contact
    func addContact(name: String, phoneNumber: String, isFavorite: Bool) {
        let newContact = Contacts(context: context) // Using Core Data entity
        newContact.name = name
        newContact.phoneNumber = phoneNumber
        newContact.isFavorite = isFavorite
        
        saveContext()
    }
    
    // MARK: - Fetch All Contacts
    func fetchContacts() -> [Contacts] {
        let fetchRequest: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching contacts: \(error)")
            return []
        }
    }
    
    // MARK: - Update Contact
    func updateContact(contact: Contacts, name: String, phoneNumber: String, isFavorite: Bool) {
        contact.name = name
        contact.phoneNumber = phoneNumber
        contact.isFavorite = isFavorite
        
        saveContext()
    }
    
    // MARK: - Delete Contact
    func deleteContact(contact: Contacts) {
        context.delete(contact)
        saveContext()
    }
    
    // MARK: - Toggle Favorite Status
    func toggleFavorite(contact: Contacts) {
        contact.isFavorite.toggle()
        saveContext()
    }

    // MARK: - Save Context
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving Core Data: \(error)")
        }
    }
}

