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
            
            // Save using the unique id as the key
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
            // Get Firebase contacts as a dictionary; if none exist, use an empty dictionary
            let firebaseContacts = snapshot.value as? [String: [String: Any]] ?? [:]
            
            // Iterate through all local contacts
            for contact in contacts {
                // Ensure the local contact has a unique id; if not, assign one.
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
                    // Compare entire dictionaries (firebase vs local)
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

    
//    //just to be slighly more efficient
//    private func updateContactInFirebaseByNotDeleting(phoneNumber: String, name: String) {
//        let sanitizedPhoneNumber = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
//
//        databaseRef.child("contacts").child(sanitizedPhoneNumber).updateChildValues(["name": name]) { error, _ in
//            if let error = error {
//                print("Error updating contact name: \(error.localizedDescription)")
//            } else {
//                print("Contact name updated successfully for \(sanitizedPhoneNumber)")
//            }
//        }
//    }
    
    //here we delete the previous contact and than add new one cz the key is no. and if the no, change it creates new contact with old being there as well .... can lead to duplicates while in core data this doesnt happen (i think so)
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
        guard let uniqueId = contact.id else { return }
        databaseRef.child("contacts").child(uniqueId).removeValue { error, _ in
            if let error = error {
                print("Error deleting contact: \(error.localizedDescription)")
            } else {
                print("Contact deleted successfully from Firebase")
            }
        }
    }
}
