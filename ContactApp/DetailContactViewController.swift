//
//  DetailContactViewController.swift
//  ContactApp
//
//  Created by Mayank Jangid on 2/21/25.
//


import UIKit

class DetailContactViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!

    var contact: Contact?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let contact = contact {
            nameLabel.text = contact.name
            phoneLabel.text = "mobile number" + "   :    " + contact.phoneNumber
        }
    }
    
    @IBAction func messageButtonTapped(_ sender: UIButton) {
        showAlert(title: "Message", message: "Messaging \(contact?.name ?? "this contact").")
    }
    
    @IBAction func callButtonTapped(_ sender: UIButton) {
        showAlert(title: "Call", message: "Calling \(contact?.name ?? "this contact").")
    }
    
    @IBAction func videoButtonTapped(_ sender: UIButton) {
        showAlert(title: "Video", message: "Starting video call with \(contact?.name ?? "this contact").")
    }
    
    @IBAction func mailButtonTapped(_ sender: UIButton) {
        showAlert(title: "Mail", message: "Sending mail to \(contact?.name ?? "this contact").")
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

