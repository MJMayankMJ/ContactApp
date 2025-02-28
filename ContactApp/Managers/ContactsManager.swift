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
    func addContact(name: String, phoneNumber: String) {
        let newContact = Contact(context: context) // Using Core Data entity
        newContact.name = name
        newContact.phoneNumber = phoneNumber
        newContact.isFavorite = false
        
        saveContext()
    }
    
    // MARK: - Fetch All Contacts and Group by First Letter
    func fetchGroupedContacts() -> [ContactGroup] {
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            let contacts = try context.fetch(fetchRequest)
            let groupedDictionary = Dictionary(grouping: contacts, by: { String($0.name?.prefix(1) ?? "#").uppercased() })
            let sortedGroups = groupedDictionary.keys.sorted().map { key in
                ContactGroup(letter: key, contacts: groupedDictionary[key]!)
            }
            return sortedGroups
        } catch {
            print("Error fetching contacts: \(error)")
            return []
        }
    }
    
        // for future use
//     MARK: - Update Contact
//    func updateContact(contact: Contact, name: String, phoneNumber: String) {
//        contact.name = name
//        contact.phoneNumber = phoneNumber
//        saveContext()
//    }
//    
//     MARK: - Delete Contact
//    func deleteContact(contact: Contact) {
//        context.delete(contact)
//        saveContext()
//    }
    
    // MARK: - Toggle Favorite Status
    func toggleFavorite(contact: Contact) {
        contact.isFavorite.toggle()
        saveContext()
    }

    // MARK: - Save Context
    func saveContext() {
        do {
            try context.save()
            print("Contacts saved successfully.")
        } catch {
            print("Error saving Core Data: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Fetch Favorite Contacts
    func fetchFavorites() -> [Contact] {
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isFavorite == true")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching favorite contacts: \(error)")
            return []
        }
    }

}

// MARK: - ContactGroup Struct
struct ContactGroup {
    let letter: String
    let contacts: [Contact]
}

// MARK: - Prepopulate Contacts (Runs Only Once)
extension ContactsManager {
    func preloadContactsIfNeeded() {
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        
        do {
            let existingContacts = try context.fetch(fetchRequest)
            print("Existing contacts count: \(existingContacts.count)")
            
            if !existingContacts.isEmpty {
                print("Contacts already exist. Skipping preload.")
                return
            }

            // List of sample names for each letter A-Z
            let names = [
                "Alice", "Adam", "Ben", "Bella", "Charlie", "Chloe", "David", "Diana",
                "Ethan", "Emma", "Frank", "Fiona", "George", "Grace", "Henry", "Hannah",
                "Ian", "Isla", "Jack", "Julia", "Kevin", "Kylie", "Liam", "Luna",
                "Mason", "Mia", "Nathan", "Nora", "Oscar", "Olivia", "Peter", "Paige",
                "Quinn", "Queenie", "Ryan", "Rachel", "Sam", "Sophia", "Tom", "Tina",
                "Umar", "Ursula", "Victor", "Violet", "William", "Wendy", "Xander", "Xenia",
                "Yusuf", "Yara", "Zane", "Zoe"
            ]

            for i in stride(from: 0, to: names.count, by: 2) {
                let contact1 = Contact(context: context)
                contact1.name = names[i]
                contact1.phoneNumber = "9876543\(i)"
                contact1.isFavorite = false
                
                let contact2 = Contact(context: context)
                contact2.name = names[i + 1]
                contact2.phoneNumber = "9876543\(i + 1)"
                contact2.isFavorite = false
            }
            print("Preloading contacts started...")
            saveContext()
            
        } catch {
            print("Error checking existing contacts: \(error)")
        }
    }

}
