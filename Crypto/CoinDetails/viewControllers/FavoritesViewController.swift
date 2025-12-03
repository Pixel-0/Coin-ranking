//
//  FavoritesViewController.swift
//  Crypto
//
//  Created by Sarah Munini Mwangangi on 03/12/2025.
//

import UIKit

final class FavoritesViewController: UIViewController {
    
    private let tableView = UITableView()
    
    private var favoriteUUIDs: [String] = []
    private var favoriteCoins: [CoinViewModel] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        view.backgroundColor = .systemBackground
        
        setupTableView()
        loadFavorites()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loadFavorites),
            name: .favoritesUpdated,
            object: nil
        )
    }
    
    // MARK: - Setup Methods
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CoinTableViewCell.self, forCellReuseIdentifier: CoinTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Load Favorites
    @objc private func loadFavorites() {
        favoriteUUIDs = FavoriteManager.shared.allFavorites()
        favoriteCoins = []
        
        let dispatchGroup = DispatchGroup()
        
        for uuid in favoriteUUIDs {
            dispatchGroup.enter()
            
            APIClient.shared.fetchCoinDetail(uuid: uuid) { [weak self] result in
                defer { dispatchGroup.leave() }
                guard let self = self else { return }
                
                switch result {
                case .success(let coinDetail):
                    let coinViewModel = CoinViewModel(
                        uuid: coinDetail.uuid,
                        symbol: coinDetail.symbol ?? "",
                        name: coinDetail.name,
                        price: coinDetail.price,
                        change: coinDetail.change,
                        iconUrl: coinDetail.iconUrl
                    )
                    self.favoriteCoins.append(coinViewModel)
                    
                case .failure(let error):
                    print("Failed to fetch coin detail for \(uuid):", error)
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableView Delegate & DataSource
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CoinTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CoinTableViewCell else {
            return UITableViewCell()
        }
        
        let coin = favoriteCoins[indexPath.row]
        cell.configure(with: coin)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCoin = favoriteCoins[indexPath.row]
        let detailVC = CoinDetailViewController(uuid: selectedCoin.uuid, name: selectedCoin.name)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row < favoriteCoins.count else { return nil }
        let coin = favoriteCoins[indexPath.row]

        let starImage = UIImage(systemName: "star.fill")?
            .withTintColor(.systemYellow, renderingMode: .alwaysOriginal)

        let action = UIContextualAction(style: .normal, title: "") { [weak self] _, _, completion in
            guard let self = self else { return }

            FavoriteManager.shared.remove(uuid: coin.uuid)

            if indexPath.row < self.favoriteCoins.count {
                self.favoriteCoins.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }

            completion(true)
        }

        action.image = starImage
        action.backgroundColor = .clear

        return UISwipeActionsConfiguration(actions: [action])
    }


}
