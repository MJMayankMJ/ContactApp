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
        
        //listening notification from detail view
        NotificationCenter.default.addObserver(self, selector: #selector(contactDeleted(_:)), name: Notification.Name("ContactDeleted"), object: nil)
        
        DispatchQueue.global(qos: .background).async {
            FirebaseManager.shared.syncLocalContacts(contacts: self.viewModel.allContacts)
            DispatchQueue.main.async {
                // ..... to do something on main thread
            }
        }
        
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    //i still dont know why i need this after i updated the delegate..... 🤔
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadContacts()
        tableView.reloadData()
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
    
    @objc private func contactDeleted(_ notification: Notification) {
        // Optionally, retrieve the deleted contact from the notification if needed:
        // if let deletedContact = notification.object as? Contact { ... }
        
        // Reload your contacts data and refresh the table view
        viewModel.loadContacts()
        tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
            let contact = viewModel.contact(at: indexPath)
            
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
                
                let messageAction = UIAction(title: "Message", image: UIImage(systemName: "message")) { [weak self] _ in
                    self?.showAlert(title: "Message", message: "Messaging \(contact.name ?? "Contact")...")
                }
                
                let callAction = UIAction(title: "Call", image: UIImage(systemName: "phone")) { [weak self] _ in
                    self?.showAlert(title: "Call", message: "Calling \(contact.name ?? "Contact")...")
                }
                
                let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                    self?.deleteContact(contact)
                }
                
                return UIMenu(title: "", children: [messageAction, callAction, deleteAction])
            }
        }
}

// MARK: - AddContactDelegate
extension ContactsViewController: AddContactDelegate {
    func didEditContact(_ contact: Contact) {
        // reload the contacts data from Core Data
        viewModel.loadContacts()
        // refresh the table view ----- contact is repositioned in the correct section
        tableView.reloadData()
    }
    
    func didAddContact(_ contact: Contact) {
        viewModel.loadContacts()
        tableView.reloadData()
    }
}

extension ContactsViewController {
    private func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        // MARK: - Handle Contact Deletion
        private func deleteContact(_ contact: Contact) {
            let alert = UIAlertController(title: "Delete Contact", message: "Are you sure you want to delete \(contact.name ?? "this contact")?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                print(contact.id)
                ContactsManager.shared.deleteContact(contact: contact)
                FirebaseManager.shared.deleteContactFromFirebase(contact: contact)
                
                self?.viewModel.loadContacts() // Refresh List
                self?.tableView.reloadData()
                
                NotificationCenter.default.post(name: Notification.Name("ContactDeleted"), object: contact)
            })
            
            present(alert, animated: true, completion: nil)
        }
}
