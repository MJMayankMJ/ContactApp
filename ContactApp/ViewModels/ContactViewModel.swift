//
//  ContactViewModel.swift
//  ContactApp
//
//  Created by Mayank Jangid on 2/27/25.
//

import Foundation

class ContactsViewModel {
    var allContacts: [Contact] = []
    private(set) var contactGroups: [ContactGroup] = []
    private(set) var filteredGroups: [ContactGroup] = []
    
    var isSearching = false
    var onContactsUpdated: (() -> Void)?

    // MARK: - Fetch Contacts
    func loadContacts() {
        contactGroups = ContactsManager.shared.fetchGroupedContacts()
        allContacts = contactGroups.flatMap { $0.contacts }
        onContactsUpdated?()
    }

    // MARK: - Search Filtering
    func filterContacts(searchText: String) {
        isSearching = !searchText.isEmpty
        
        if isSearching {
            let filteredContacts = allContacts.filter { $0.name?.lowercased().contains(searchText.lowercased()) ?? false }
            let groupedDictionary = Dictionary(grouping: filteredContacts, by: { String($0.name?.prefix(1) ?? "#") })
            filteredGroups = groupedDictionary.keys.sorted().map { key in
                ContactGroup(letter: key, contacts: groupedDictionary[key]!)
            }
        }
        
        onContactsUpdated?()
    }

    // MARK: - TableView Helpers
    func numberOfSections() -> Int {
        return isSearching ? filteredGroups.count : contactGroups.count
    }
    
    func titleForSection(_ section: Int) -> String {
        return isSearching ? filteredGroups[section].letter : contactGroups[section].letter
    }
    
    func numberOfRows(in section: Int) -> Int {
        return isSearching ? filteredGroups[section].contacts.count : contactGroups[section].contacts.count
    }
    
    func contact(at indexPath: IndexPath) -> Contact {
        return isSearching ? filteredGroups[indexPath.section].contacts[indexPath.row] : contactGroups[indexPath.section].contacts[indexPath.row]
    }
    
}

