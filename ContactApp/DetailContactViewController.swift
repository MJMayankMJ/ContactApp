//
//  DetailContactViewController.swift
//  ContactApp
//
//  Created by Mayank Jangid on 2/21/25.
//


import UIKit

protocol FavoritesDelegate: AnyObject {
    func didUpdateFavorites(_ contact: Contact, isFavorite: Bool)
}

class DetailContactViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    
    var contact: Contact?
    weak var favoritesDelegate: FavoritesDelegate?
    var favoriteContacts = FavoritesManager.shared.getFavorites() //to check if the tap is working purely for debugging

    override func viewDidLoad() {
        super.viewDidLoad()

        if let contact = contact {
            nameLabel.text = contact.name
            phoneLabel.text = "mobile number" + "   :    " + contact.phoneNumber
            updateFavoriteButton()
        }
        if isSmallScreenDevice() {
            removeButtonTitles()
        }
    }

    @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        guard let contact = contact else { return }

        let isNowFavorite = !FavoritesManager.shared.isFavorite(contact)
        FavoritesManager.shared.toggleFavorite(contact)

        favoritesDelegate?.didUpdateFavorites(contact, isFavorite: isNowFavorite)
        updateFavoriteButton()
        
        //to check
        for contact in favoriteContacts {
            print(contact)
        }
    }

    
    private func updateFavoriteButton() {
        guard let contact = contact else { return }
        let isFavorite = FavoritesManager.shared.isFavorite(contact)
        let imageName = isFavorite ? "star.fill" : "star"
        favoriteButton.image = UIImage(systemName: imageName)

    }

    private func isSmallScreenDevice() -> Bool {
        let screenHeight = UIScreen.main.bounds.height
        return screenHeight <= 667 // Covers iPhone SE, iPhone 8, iPhone 6s
    }

    private func removeButtonTitles() {
        messageButton.setTitle("", for: .normal)
        callButton.setTitle("", for: .normal)
        videoButton.setTitle("", for: .normal)
        mailButton.setTitle("", for: .normal)
    }

}

extension DetailContactViewController {
    // MARK: - Button Actions
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
