//
//  DetailContactViewModel.swift
//  ContactApp
//
//  Created by Mayank Jangid on 2/27/25.
//

import UIKit

class DetailContactViewModel {
    
    private let favoritesManager = FavoritesManager.shared
    var contact: Contact
    
    // Callback for UI updates
    var onFavoriteStatusChanged: ((Bool) -> Void)?
    
    init(contact: Contact) {
        self.contact = contact
    }
    
    // Get current favorite status
    func isFavorite() -> Bool {
        return favoritesManager.isFavorite(contact)
    }
    
    // Toggle favorite status
    func toggleFavorite() {
        favoritesManager.toggleFavorite(contact)
        let isNowFavorite = isFavorite()
        onFavoriteStatusChanged?(isNowFavorite)
    }
}
