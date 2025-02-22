//
//  FavouritesViewController.swift
//  ContactApp
//
//  Created by Mayank Jangid on 2/21/25.
//

import UIKit

class FavoritesViewController: UITableViewController, FavoritesDelegate {

    var favoriteContacts: [Contact] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadFavorites()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites() // Refresh favorites when the tab appears
    }

    func loadFavorites() {
        favoriteContacts = FavoritesManager.shared.getFavorites()
        tableView.reloadData()
    }

    // MARK: - UITableView Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteContacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        let contact = favoriteContacts[indexPath.row]
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = contact.phoneNumber
        return cell
    }

    // MARK: - FavoritesDelegate
    func didUpdateFavorites(_ contact: Contact, isFavorite: Bool) {
        loadFavorites() // Refresh the favorites list when updated
    }
}
