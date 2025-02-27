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
    
    weak var favoritesDelegate: FavoritesDelegate?
    var viewModel: DetailContactViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
    }
    
    private func setupUI() {
        nameLabel.text = viewModel.contact.name
        phoneLabel.text = "mobile number: \(viewModel.contact.phoneNumber ?? "")"
        updateFavoriteButton()
        
        if isSmallScreenDevice() {
            removeButtonTitles()
        }
    }
    
    private func setupViewModel() {
        viewModel.onFavoriteStatusChanged = { [weak self] isFavorite in
            self?.updateFavoriteButton()
            self?.favoritesDelegate?.didUpdateFavorites(self!.viewModel.contact, isFavorite: isFavorite)
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        viewModel.toggleFavorite()
    }

    private func updateFavoriteButton() {
        let imageName = viewModel.isFavorite() ? "star.fill" : "star"
        favoriteButton.image = UIImage(systemName: imageName)
    }

    private func isSmallScreenDevice() -> Bool {
        return UIScreen.main.bounds.height <= 667 // iPhone SE, 8, 6s
    }

    private func removeButtonTitles() {
        [messageButton, callButton, videoButton, mailButton].forEach { $0?.setTitle("", for: .normal) }
    }
}


extension DetailContactViewController {
    // MARK: - Button Actions
    @IBAction func messageButtonTapped(_ sender: UIButton) {
        showAlert(title: "Message", message: "Messaging \(viewModel.contact.name ?? "this contact").")
    }
    
    @IBAction func callButtonTapped(_ sender: UIButton) {
        showAlert(title: "Call", message: "Calling \(viewModel.contact.name ?? "this contact").")
    }
    
    @IBAction func videoButtonTapped(_ sender: UIButton) {
        showAlert(title: "Video", message: "Starting video call with \(viewModel.contact.name ?? "this contact").")
    }
    
    @IBAction func mailButtonTapped(_ sender: UIButton) {
        showAlert(title: "Mail", message: "Sending mail to \(viewModel.contact.name ?? "this contact").")
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
