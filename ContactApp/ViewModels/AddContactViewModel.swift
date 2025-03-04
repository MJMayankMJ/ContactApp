//
//  AddContactViewModel.swift
//  ContactApp
//
//  Created by Mayank Jangid on 2/27/25.
//

import Foundation

class AddContactViewModel {
    
    var onContactAdded: ((Contact) -> Void)?
    var contactToEdit: Contact?
    
    func saveContact(name: String, phoneNumber: String) {
        ContactsManager.shared.addContact(name: name, phoneNumber: phoneNumber)
        
        if let groupedContacts = ContactsManager.shared.fetchGroupedContacts().first(where: { $0.letter == String(name.prefix(1)).uppercased() }),
           let newContact = groupedContacts.contacts.last {
            onContactAdded?(newContact)
        }
    }

    func editContact(contact: Contact, name: String, phoneNumber: String) {
        // Update the contact's information
        contact.name = name
        contact.phoneNumber = phoneNumber
        
        ContactsManager.shared.updateContact(contact: contact, name: name, phoneNumber: phoneNumber)
        FirebaseManager.shared.updateContactInFirebase(contact: contact)
        
        onContactAdded?(contact)
    }
}

