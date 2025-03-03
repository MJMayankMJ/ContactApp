//
//  AddContactViewController.swift
//  ContactApp
//
//  Created by Mayank Jangid on 2/21/25.
//

import UIKit

protocol AddContactDelegate: AnyObject {
    func didAddContact(_ contact: Contact)
    func didEditContact(_ contact: Contact)
}

class AddContactViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    weak var delegate: AddContactDelegate?
    private let viewModel = AddContactViewModel() // ViewModel instance
    var contactToEdit: Contact? // Property to store the contact being edited

    override func viewDidLoad() {
        super.viewDidLoad()
//        print("Name TextField: \(nameTextField)")
//        print("Phone TextField: \(phoneTextField)")
        setupNavigationBar()
        setupViewModel()
        setupForEditing()
    }
    
    // MARK: - Setup Navigation Bar
    private func setupNavigationBar() {
        if contactToEdit != nil {
            title = "Edit Contact"
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .save,
                target: self,
                action: #selector(saveContactPressed)
            )
        } else {
            title = "New Contact"
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .save,
                target: self,
                action: #selector(saveContactPressed)
            )
        }
    }
    
    // MARK: - Setup ViewModel
    private func setupViewModel() {
        viewModel.onContactAdded = { [weak self] contact in
            if let contact = self?.contactToEdit {
                self?.delegate?.didEditContact(contact)
            } else {
                self?.delegate?.didAddContact(contact)
            }
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Setup for Editing
    private func setupForEditing() {
        guard let contact = contactToEdit else { return }
        print(contact.name)
        nameTextField.text = contact.name
        phoneTextField.text = contact.phoneNumber
    }
    
    
    // MARK: - Save Contact
    @objc private func saveContactPressed() {
        guard let name = nameTextField.text, !name.isEmpty,
              let phoneNumber = phoneTextField.text, !phoneNumber.isEmpty else {
            showAlert("Missing Information", "Please enter both name and phone number.")
            return
        }

        if let contact = contactToEdit {
            // Update the existing contact
            viewModel.editContact(contact: contact, name: name, phoneNumber: phoneNumber)
        } else {
            // Add a new contact
            viewModel.saveContact(name: name, phoneNumber: phoneNumber)
        }
    }
    
    // MARK: - Show Alert
    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
