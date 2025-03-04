//
//  FirebaseManager.swift
//  ContactApp
//
//  Created by Mayank Jangid on 2/28/25.
//


import FirebaseDatabase
import Foundation

class FirebaseManager {
    static let shared = FirebaseManager()
    private let databaseRef = Database.database().reference()
    
    // MARK: - Save a Single Contact
    
    func saveContactToFirebase(contact: Contact) {
            // Ensure the contact has a unique id. If not, you can generate one.
            if contact.id == nil {
                contact.id = UUID().uuidString
            }
            guard let uniqueId = contact.id else { return }
            
            // Create dictionary to save
            let contactDict: [String: Any] = [
                "name": contact.name ?? "",
                "phoneNumber": contact.phoneNumber ?? "",
                "isFavorite": contact.isFavorite
            ]
            
        
            databaseRef.child("contacts").child(uniqueId).setValue(contactDict) { error, _ in
                if let error = error {
                    print("Error saving contact: \(error.localizedDescription)")
                } else {
                    print("Contact saved successfully with key \(uniqueId)")
                }
            }
        }

    
    // MARK: - Sync Firebase from local contacts
    
//    func syncLocalContacts(contacts: [Contact]) {
//        databaseRef.child("contacts").observeSingleEvent(of: .value) { snapshot in
//            var existingContacts = Set<String>()
//
//            // extract existing contacts' phone numbers from Firebase
//            if let contactsData = snapshot.value as? [String: [String: Any]] {
//                for (_, contactInfo) in contactsData {
//                    if let phoneNumber = contactInfo["phoneNumber"] as? String {
//                        existingContacts.insert(phoneNumber)
//                    }
//                }
//            }
//
//            // upload only new contacts (not in Firebase)
//            for contact in contacts {
//                if let phoneNumber = contact.phoneNumber, !existingContacts.contains(phoneNumber) {
//                    self.saveContactToFirebase(contact: contact)
//                }
//            }
//        }
//    }
    
    func syncLocalContacts(contacts: [Contact]) {
        databaseRef.child("contacts").observeSingleEvent(of: .value) { snapshot in
            let firebaseContacts = snapshot.value as? [String: [String: Any]] ?? [:]
            
            for contact in contacts {
                if contact.id == nil {
                    contact.id = UUID().uuidString
                }
                guard let uniqueId = contact.id else { continue }
                
                // Build a dictionary representing the local contact data
                let localData: [String: Any] = [
                    "name": contact.name ?? "",
                    "phoneNumber": contact.phoneNumber ?? "",
                    "isFavorite": contact.isFavorite
                ]
                
                if let firebaseData = firebaseContacts[uniqueId] {
                    if !NSDictionary(dictionary: firebaseData).isEqual(to: localData) {
                        // Data is different; update the Firebase record
                        self.updateContactInFirebase(contact: contact)
                    }
                } else {
                    // No record found in Firebase, so save this new contact
                    self.saveContactToFirebase(contact: contact)
                }
            }
        }
    }
    
    func updateContactInFirebase(contact: Contact) {
        guard let uniqueId = contact.id else { return }
        let updatedData: [String: Any] = [
            "name": contact.name ?? "",
            "phoneNumber": contact.phoneNumber ?? "",
            "isFavorite": contact.isFavorite
        ]
        
        databaseRef.child("contacts").child(uniqueId).updateChildValues(updatedData) { error, _ in
            if let error = error {
                print("Error updating contact: \(error.localizedDescription)")
            } else {
                print("Contact updated successfully")
            }
        }
    }
    
    func deleteContactFromFirebase(contact: Contact) {
        guard let uniqueId = contact.id else {
            print("Error: Contact ID is nil. Cannot proceed.")
            return
        }
        databaseRef.child("contacts").child(uniqueId).removeValue { error, _ in
            if let error = error {
                print("Error deleting contact: \(error.localizedDescription)")
            } else {
                print("Contact deleted successfully from Firebase")
            }
        }
    }
}
