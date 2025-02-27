//
//  ContactsViewController.swift
//  ContactApp
//
//  Created by Mayank Jangid on 2/21/25.
//

import UIKit

class ContactsViewController: UITableViewController, UISearchResultsUpdating {
    private let viewModel = ContactsViewModel()
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupSearchController()
        setupViewModel()
        
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
        definesPresentationContext = true
    }

    // MARK: - Setup ViewModel
    private func setupViewModel() {
        viewModel.onContactsUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.loadContacts()
    }
    
    @objc func addContact() {
        let addVC = storyboard?.instantiateViewController(identifier: "AddContactViewController") as! AddContactViewController
        addVC.delegate = self
        navigationController?.pushViewController(addVC, animated: true)
    }

    // MARK: - UITableView Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForSection(section)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        let contact = viewModel.contact(at: indexPath)
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = contact.phoneNumber
        return cell
    }

    // MARK: - Search Filtering
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        viewModel.filterContacts(searchText: searchText)
    }

    // MARK: - Navigation to DetailContactViewController
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let contact = viewModel.contact(at: indexPath) // it is what it is
        
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailContactViewController") as! DetailContactViewController
        detailVC.viewModel = DetailContactViewModel(contact: contact)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - AddContactDelegate
extension ContactsViewController: AddContactDelegate {
    func didAddContact(_ contact: Contact) {
        viewModel.loadContacts() // Refresh sections after adding a new contact
    }
}
