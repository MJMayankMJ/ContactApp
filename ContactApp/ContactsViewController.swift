//
//  ContactsViewController.swift
//  ContactApp
//
//  Created by Mayank Jangid on 2/21/25.
//

import UIKit

class ContactsViewController: UITableViewController {

    var contactSections: [ContactSection] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        updateSectionedContacts()
    }

    // Setup add button
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addContact)
        )
    }

    // Group contacts into sections
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
        return contactSections.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contactSections[section].letter
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactSections[section].contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        let contact = contactSections[indexPath.section].contacts[indexPath.row]
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = contact.phoneNumber
        return cell
    }

    // MARK: - Navigation to DetailContactViewController

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailContactViewController") as! DetailContactViewController
        detailVC.contact = contactSections[indexPath.section].contacts[indexPath.row]

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
