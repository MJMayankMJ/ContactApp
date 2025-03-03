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
        guard let phoneNumber = contact.phoneNumber else { return }
        
        // sanitizing phone number to make it Firebase-key friendly
        let sanitizedPhoneNumber = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)

        // Create dictionary
        let contactDict: [String: Any] = [
            "name": contact.name ?? "",
            "phoneNumber": phoneNumber,
            "isFavorite": contact.isFavorite
        ]
        
        // Use phone number as the Firebase key
        databaseRef.child("contacts").child(sanitizedPhoneNumber).setValue(contactDict) { error, _ in
            if let error = error {
                print("Error saving contact: \(error.localizedDescription)")
            } else {
                print("Contact saved successfully with key \(sanitizedPhoneNumber)")
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
            var existingContacts = [String: String]() // [phoneNumber: name]

            // Extract existing contacts' phone numbers and names from Firebase
            if let contactsData = snapshot.value as? [String: [String: Any]] {
                for (_, contactInfo) in contactsData {
                    if let phoneNumber = contactInfo["phoneNumber"] as? String,
                       let name = contactInfo["name"] as? String {
                        existingContacts[phoneNumber] = name
                    }
                }
            }

            // Compare and sync contacts
            for contact in contacts {
                guard let phoneNumber = contact.phoneNumber else { continue }

                if let existingName = existingContacts[phoneNumber] {
                    // If contact exists but name is different, update it
                    if existingName != contact.name {
                        self.updateContactInFirebaseByNotDeleting(phoneNumber: phoneNumber, name: contact.name!)
                    }
                } else {
                    // New contact, save to Firebase
                    self.saveContactToFirebase(contact: contact)
                }
            }
        }
    }
    
    //just to be slighly more efficient
    private func updateContactInFirebaseByNotDeleting(phoneNumber: String, name: String) {
        let sanitizedPhoneNumber = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)

        databaseRef.child("contacts").child(sanitizedPhoneNumber).updateChildValues(["name": name]) { error, _ in
            if let error = error {
                print("Error updating contact name: \(error.localizedDescription)")
            } else {
                print("Contact name updated successfully for \(sanitizedPhoneNumber)")
            }
        }
    }
    
    //here we delete the previous contact and than add new one cz the key is no. and if the no, change it creates new contact with old being there as well .... can lead to duplicates while in core data this doesnt happen (i think so)
    func updateContactInFirebase(contact: Contact) {
        guard let phoneNumber = contact.phoneNumber else { return }
        let sanitizedPhoneNumber = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        let updatedData: [String: Any] = [
            "name": contact.name ?? "",
            "phoneNumber": contact.phoneNumber ?? "",
            "isFavorite": contact.isFavorite
        ]
        
        databaseRef.child("contacts").child(sanitizedPhoneNumber).updateChildValues(updatedData) { error, _ in
            if let error = error {
                print("Error updating contact: \(error.localizedDescription)")
            } else {
                print("Contact updated successfully")
            }
        }
    }
}
