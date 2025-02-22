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

    Contact(name: "David Dawson", phoneNumber: "777-888-9999"),
    Contact(name: "Diana Davis", phoneNumber: "888-999-0000"),

    Contact(name: "Ethan Edwards", phoneNumber: "999-000-1111"),
    Contact(name: "Emma Evans", phoneNumber: "000-111-2222"),

    Contact(name: "Felix Fisher", phoneNumber: "111-222-3334"),
    Contact(name: "Fiona Foster", phoneNumber: "222-333-4445"),

    Contact(name: "George Green", phoneNumber: "333-444-5556"),
    Contact(name: "Grace Garcia", phoneNumber: "444-555-6667"),

    Contact(name: "Henry Harris", phoneNumber: "555-666-7778"),
    Contact(name: "Hannah Hughes", phoneNumber: "666-777-8889"),

    Contact(name: "Isaac Ingram", phoneNumber: "777-888-9990"),
    Contact(name: "Isla Irwin", phoneNumber: "888-999-0001"),

    Contact(name: "Jack Johnson", phoneNumber: "999-000-1112"),
    Contact(name: "Julia James", phoneNumber: "000-111-2223"),

    Contact(name: "Kevin King", phoneNumber: "111-222-3335"),
    Contact(name: "Kylie Knight", phoneNumber: "222-333-4446"),

    Contact(name: "Liam Lewis", phoneNumber: "333-444-5557"),
    Contact(name: "Lily Lopez", phoneNumber: "444-555-6668"),

    Contact(name: "Michael Miller", phoneNumber: "555-666-7779"),
    Contact(name: "Mia Mitchell", phoneNumber: "666-777-8880"),

    Contact(name: "Noah Nelson", phoneNumber: "777-888-9991"),
    Contact(name: "Natalie Norris", phoneNumber: "888-999-0002"),

    Contact(name: "Oliver Owens", phoneNumber: "999-000-1113"),
    Contact(name: "Olivia Ortega", phoneNumber: "000-111-2224"),

    Contact(name: "Paul Peterson", phoneNumber: "111-222-3336"),
    Contact(name: "Penelope Parker", phoneNumber: "222-333-4447"),

    Contact(name: "Quinn Quinn", phoneNumber: "333-444-5558"),
    Contact(name: "Queenie Quigley", phoneNumber: "444-555-6669"),

    Contact(name: "Ryan Roberts", phoneNumber: "555-666-7780"),
    Contact(name: "Rachel Russell", phoneNumber: "666-777-8891"),

    Contact(name: "Samuel Scott", phoneNumber: "777-888-9902"),
    Contact(name: "Sophia Simmons", phoneNumber: "888-999-0013"),

    Contact(name: "Thomas Thompson", phoneNumber: "999-000-1124"),
    Contact(name: "Taylor Turner", phoneNumber: "000-111-2235"),

    Contact(name: "Umar Underwood", phoneNumber: "111-222-3346"),
    Contact(name: "Uma Urban", phoneNumber: "222-333-4457"),

    Contact(name: "Victor Vargas", phoneNumber: "333-444-5568"),
    Contact(name: "Violet Vincent", phoneNumber: "444-555-6679"),

    Contact(name: "William Watson", phoneNumber: "555-666-7789"),
    Contact(name: "Wendy White", phoneNumber: "666-777-8890"),

    Contact(name: "Xander Xavier", phoneNumber: "777-888-9901"),
    Contact(name: "Xena Xiong", phoneNumber: "888-999-0012"),

    Contact(name: "Yusuf Young", phoneNumber: "999-000-1123"),
    Contact(name: "Yvonne York", phoneNumber: "000-111-2234"),

    Contact(name: "Zachary Zimmerman", phoneNumber: "111-222-3345"),
    Contact(name: "Zoe Zane", phoneNumber: "222-333-4456")
]


// Function to group contacts by first letter
func getSectionedContacts() -> [ContactSection] {
    let groupedDictionary = Dictionary(grouping: contacts, by: { String($0.name.prefix(1)) })
    let sortedSections = groupedDictionary.keys.sorted().map { key in
        ContactSection(letter: key, contacts: groupedDictionary[key]!.sorted { $0.name < $1.name })
    }
    return sortedSections
}
