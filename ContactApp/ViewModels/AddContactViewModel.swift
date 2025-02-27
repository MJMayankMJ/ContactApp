//
//  AddContactViewModel.swift
//  ContactApp
//
//  Created by Mayank Jangid on 2/27/25.
//

import Foundation

class AddContactViewModel {
    
    var onContactAdded: ((Contact) -> Void)?
    
    func saveContact(name: String, phoneNumber: String) {
        ContactsManager.shared.addContact(name: name, phoneNumber: phoneNumber)
        
        if let groupedContacts = ContactsManager.shared.fetchGroupedContacts().first(where: { $0.letter == String(name.prefix(1)).uppercased() }),
           let newContact = groupedContacts.contacts.last {
            onContactAdded?(newContact)
        }
    }
}
