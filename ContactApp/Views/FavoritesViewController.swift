//
//  FavouritesViewController.swift
//  ContactApp
//
//  Created by Mayank Jangid on 2/21/25.
//

import UIKit

class FavoritesViewController: UITableViewController, FavoritesDelegate {

    private let viewModel = FavoritesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        viewModel.loadFavorites()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavorites()
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ContactCell")
        //why register inside a table view controller?
        //the below reasoning is purely guess work atm
        //cz its not the thingie from itself its the thing which we are using from another table view controller (ContactTBC) so i think generally it automatically does that only if its own TBC (table view controller) and when u try to use it like this u might need to register it
        // edit 2 : all these things were done when i tried to use tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) in FavoriteViewController (TBC) down below
        //so why was i doing that?
        //idk semmed smart atm
        //the above code is a legacy this that is important for me too understand you can ignore
        //the above thing is a legacy thing; you can ignore; it is important for me too understand
    }

    private func setupViewModel() {
        viewModel.onFavoritesUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    // MARK: - UITableView Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favoriteContacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath)
        let contact = viewModel.contact(at: indexPath)
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = contact.phoneNumber
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let contact = viewModel.contact(at: indexPath)
        let alert = UIAlertController(title: "Call", message: "Calling \(contact.name!)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }

    // MARK: - FavoritesDelegate
    func didUpdateFavorites(_ contact: Contact, isFavorite: Bool) {
        viewModel.updateFavorites(contact: contact, isFavorite: isFavorite)
    }
}
