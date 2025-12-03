//
//  FavoriteManager.swift
//  Crypto
//
//  Created by Sarah Munini Mwangangi on 03/12/2025.
//

import Foundation

final class FavoriteManager {
    static let shared = FavoriteManager()
    private let key = "favorite_coins"
    private var favorites: Set<String>
    
    
    private init() {
        let arr = UserDefaults.standard.stringArray(forKey: key) ?? []
        favorites = Set(arr)
    }
    
    
    func isFavorite(uuid: String) -> Bool { favorites.contains(uuid) }
    
    
    func add(uuid: String) {
        favorites.insert(uuid)
        save()
    }
    
    
    func remove(uuid: String) {
        favorites.remove(uuid)
        save()
    }
    
    
    func allFavorites() -> [String] { Array(favorites) }
    
    
    private func save() {
        UserDefaults.standard.set(Array(favorites), forKey: key)
        NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
    }
}


extension Notification.Name {
    static let favoritesUpdated = Notification.Name("favoritesUpdated")
}
