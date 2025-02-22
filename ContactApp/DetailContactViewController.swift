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
}
