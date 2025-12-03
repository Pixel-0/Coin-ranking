//
//  UIViewController+Extenstion.swift
//  Crypto
//
//  Created by Sarah Munini Mwangangi on 03/12/2025.
//


import UIKit

extension UIViewController {
    func swipeActionForFavorite(
        coin: Coin,
        remove: @escaping () -> Void
    ) -> UISwipeActionsConfiguration {
        let isFavorite = FavoriteManager.shared.isFavorite(uuid: coin.uuid)
        let starImage = UIImage(systemName: isFavorite ? "star.fill" : "star")?
            .withTintColor(.systemYellow, renderingMode: .alwaysOriginal)

        let action = UIContextualAction(style: .normal, title: "") { _, _, completion in
            remove()
            completion(true)
        }

        action.image = starImage
        action.backgroundColor = .clear

        return UISwipeActionsConfiguration(actions: [action])
    }
}

