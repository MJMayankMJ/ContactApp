//
//  ContactsViewController.swift
//  ContactApp
//
//  Created by Mayank Jangid on 2/21/25.
//

import UIKit

class ContactsViewController: UITableViewController, UISearchResultsUpdating {

    var contactSections: [ContactSection] = []
    var filteredSections: [ContactSection] = [] // Stores filtered contacts
    var isSearching = false

    let searchController = UISearchController(searchResultsController: nil)
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationItem.searchController = searchController // Restore search bar
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationItem.searchController = nil // Remove search bar from other screens
//    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupSearchController()
        updateSectionedContacts()
        
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    // MARK: - Setup Navigation Bar
    private func setupNavigationBar() {
        title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addContact)
        )
    }

    // MARK: - Setup Search Controller
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Contacts"
        navigationItem.searchController = searchController
        definesPresentationContext = true // idk why but fixes lots of glitches in other screen
    }

    // MARK: - Group Contacts into Sections
    private func updateSectionedContacts() {
        let groupedDictionary = Dictionary(grouping: contacts, by: { String($0.name.prefix(1)) })
        contactSections = groupedDictionary.keys.sorted().map { key in
            ContactSection(letter: key, contacts: groupedDictionary[key]!.sorted { $0.name < $1.name })
        }
        tableView.reloadData()
    }

    @objc func addContact() {
        let addVC = storyboard?.instantiateViewController(identifier: "AddContactViewController") as! AddContactViewController
        addVC.delegate = self
        navigationController?.pushViewController(addVC, animated: true)
    }

    // MARK: - UITableView Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return isSearching ? filteredSections.count : contactSections.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isSearching ? filteredSections[section].letter : contactSections[section].letter
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredSections[section].contacts.count : contactSections[section].contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        let contact = isSearching ? filteredSections[indexPath.section].contacts[indexPath.row] : contactSections[indexPath.section].contacts[indexPath.row]
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = contact.phoneNumber
        return cell
    }

    // MARK: - Search Filtering
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text?.lowercased() ?? ""
        isSearching = !searchText.isEmpty

        if isSearching {
            let filteredContacts = contacts.filter { $0.name.lowercased().contains(searchText) }
            let groupedDictionary = Dictionary(grouping: filteredContacts, by: { String($0.name.prefix(1)) })
            filteredSections = groupedDictionary.keys.sorted().map { key in
                ContactSection(letter: key, contacts: groupedDictionary[key]!.sorted { $0.name < $1.name })
            }
        }

        tableView.reloadData()
    }

    // MARK: - Navigation to DetailContactViewController and the favourite schinanigan
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailContactViewController") as! DetailContactViewController
        let contact = isSearching ? filteredSections[indexPath.section].contacts[indexPath.row] : contactSections[indexPath.section].contacts[indexPath.row]
        detailVC.contact = contact

        if let tabBarVC = tabBarController,
           let favoritesNav = tabBarVC.viewControllers?.first as? UINavigationController,
           let favoritesVC = favoritesNav.topViewController as? FavoritesViewController {
            detailVC.favoritesDelegate = favoritesVC
        }

        navigationController?.pushViewController(detailVC, animated: true)
    }

}

// MARK: - AddContactDelegate
extension ContactsViewController: AddContactDelegate {
    func didAddContact(_ contact: Contact) {
        contacts.append(contact)
        updateSectionedContacts() // Refresh sections after adding a new contact
    }
}
