//
//  FirebaseManager.swift
//  ContactApp
//
//  Created by Mayank Jangid on 2/28/25.
//


import FirebaseDatabase

class FirebaseManager {
    static let shared = FirebaseManager()
    private let databaseRef = Database.database().reference()
    
    // MARK: - Save a Single Contact
    
    func saveContactToFirebase(contact: Contact) {
        // convert the Contact into a dict
        let contactDict: [String: Any] = [
            "name": contact.name ?? "",
            "phoneNumber": contact.phoneNumber ?? "",
            "isFavorite": contact.isFavorite
        ]
        
        // generate a unique key for the contact.
        let contactKey = databaseRef.child("contacts").childByAutoId().key ?? UUID().uuidString
        
        databaseRef.child("contacts").child(contactKey).setValue(contactDict) { error, _ in
            if let error = error {
                print("Error saving contact: \(error.localizedDescription)")
            } else {
                print("Contact saved successfully with key \(contactKey)")
            }
        }
    }
    
    // MARK: - Sync Local Contacts to Firebase
    
    func syncLocalContacts(contacts: [Contact]) {
        for contact in contacts {
            saveContactToFirebase(contact: contact)
        }
    }
    
    // MARK: - Observe Contacts from Firebase
    
    /// Observes the "contacts" node in Firebase and returns an array of Contact objects via the completion handler.
    func observeContacts(completion: @escaping ([Contact]) -> Void) {
        databaseRef.child("contacts").observe(.value) { snapshot in
            var contacts: [Contact] = []
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let dict = childSnapshot.value as? [String: Any],
                   let name = dict["name"] as? String,
                   let phoneNumber = dict["phoneNumber"] as? String,
                   let isFavorite = dict["isFavorite"] as? Bool {
                    
                    // Create a Contact object. Adjust the initializer as needed.
                    let contact = Contact(name: name, phoneNumber: phoneNumber, isFavorite: isFavorite)
                    contacts.append(contact)
                }
            }
            completion(contacts)
        }
    }
}
