//
//  FavoriteManager.swift
//  ContactApp
//
//  Created by Mayank Jangid on 2/22/25.
//

import Foundation

class FavoritesManager {
    static let shared = FavoritesManager()
    
    private var favoriteContacts: [Contact] = []
    
    private init() {}

    func toggleFavorite(_ contact: Contact) {
        if let index = favoriteContacts.firstIndex(where: { $0.name == contact.name }) {
            favoriteContacts.remove(at: index) // Remove if already in favorites
        } else {
            favoriteContacts.append(contact) // Add if not in favorites
        }
    }

    func isFavorite(_ contact: Contact) -> Bool {
        return favoriteContacts.contains(where: { $0.name == contact.name })
    }

    func getFavorites() -> [Contact] {
        return favoriteContacts
    }
}
