//
//  FavoriteManager.swift
//  ContactApp
//
//  Created by Mayank Jangid on 2/22/25.
//

import Foundation
import CoreData



class FavoritesManager {
    static let shared = FavoritesManager()
    
    func toggleFavorite(_ contact: Contact) {
        contact.isFavorite.toggle()
        ContactsManager.shared.saveContext()
    }
    
    func isFavorite(_ contact: Contact) -> Bool {
        return contact.isFavorite
    }

    func getFavorites() -> [Contact] {
        return ContactsManager.shared.fetchFavorites()
    }
}
