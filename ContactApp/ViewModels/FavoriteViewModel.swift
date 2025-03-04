//
//  FavoriteViewModel.swift
//  ContactApp
//
//  Created by Mayank Jangid on 2/27/25.
//

import Foundation

class FavoritesViewModel {
    private(set) var favoriteContacts: [Contact] = []
    
    var onFavoritesUpdated: (() -> Void)?
    
    func loadFavorites() {
        favoriteContacts = ContactsManager.shared.fetchFavorites()
        onFavoritesUpdated?()
    }
    
    func contact(at indexPath: IndexPath) -> Contact {
        return favoriteContacts[indexPath.row]
    }
    
    func updateFavorites(contact: Contact, isFavorite: Bool) {
        loadFavorites() // Refresh the data
    }
}
