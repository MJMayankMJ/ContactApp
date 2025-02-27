//
//  AddContactViewController.swift
//  ContactApp
//
//  Created by Mayank Jangid on 2/21/25.
//

import UIKit

protocol AddContactDelegate: AnyObject {
    func didAddContact(_ contact: Contact)
}

class AddContactViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    weak var delegate: AddContactDelegate?
    private let viewModel = AddContactViewModel() // ViewModel instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViewModel()
    }
    
    // MARK: - Setup Navigation Bar
    private func setupNavigationBar() {
        title = "New Contact"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveContactPressed)
        )
    }
    
    // MARK: - Setup ViewModel
    private func setupViewModel() {
        viewModel.onContactAdded = { [weak self] contact in
            self?.delegate?.didAddContact(contact)
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Save Contact
    @objc private func saveContactPressed() {
        guard let name = nameTextField.text, !name.isEmpty,
              let phoneNumber = phoneTextField.text, !phoneNumber.isEmpty else {
            showAlert("Missing Information", "Please enter both name and phone number.")
            return
        }
        
        viewModel.saveContact(name: name, phoneNumber: phoneNumber)
    }
    
    // MARK: - Show Alert
    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
