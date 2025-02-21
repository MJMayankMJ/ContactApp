//
//  Contact.swift
//  ContactApp
//
//  Created by Mayank Jangid on 2/21/25.
//

import Foundation

struct Contact {
    let name: String
    let phoneNumber: String
}

struct ContactSection {
    let letter: String
    let contacts: [Contact]
}

// Sample contacts data
var contacts: [Contact] = [
    Contact(name: "Alice Anderson", phoneNumber: "111-222-3333"),
    Contact(name: "Aaron Adams", phoneNumber: "222-333-4444"),
    Contact(name: "Ben Baker", phoneNumber: "333-444-5555"),
    Contact(name: "Bella Brooks", phoneNumber: "444-555-6666"),
    Contact(name: "Charlie Carter", phoneNumber: "555-666-7777"),
    Contact(name: "Chloe Cooper", phoneNumber: "666-777-8888"),
    // Add more contacts...
]

// Function to group contacts by first letter
func getSectionedContacts() -> [ContactSection] {
    let groupedDictionary = Dictionary(grouping: contacts, by: { String($0.name.prefix(1)) })
    let sortedSections = groupedDictionary.keys.sorted().map { key in
        ContactSection(letter: key, contacts: groupedDictionary[key]!.sorted { $0.name < $1.name })
    }
    return sortedSections
}

