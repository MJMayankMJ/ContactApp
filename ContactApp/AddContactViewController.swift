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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add Contact"
    }
    
    @IBAction func saveContact(_ sender: UIBarButtonItem) {
        guard let name = nameTextField.text, !name.isEmpty,
              let phone = phoneTextField.text, !phone.isEmpty else {
            return
        }
        
        let newContact = Contact(name: name, phoneNumber: phone)
        delegate?.didAddContact(newContact)
        navigationController?.popViewController(animated: true)
    }
}
