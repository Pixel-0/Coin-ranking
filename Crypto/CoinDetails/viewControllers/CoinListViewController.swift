//
//  CoinListViewController.swift
//  Crypto
//
//  Created by Sarah Munini Mwangangi on 03/12/2025.
//

import UIKit

final class CoinListViewController: UIViewController {
    
    // MARK: - UI Elements
    private let tableView = UITableView()
    private let filterSegmentedControl = UISegmentedControl(items: ["All", "Highest Price", "Best 24h"])
    
    // MARK: - Data
    private var coins: [Coin] = []
    private var offset = 0
    private var isLoading = false
    private var totalCoinsLoaded = 0
    private let pageSize = 20
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Top 100 Coins"
        view.backgroundColor = .systemBackground
        
        setupTableView()
        setupNavigationBar()
        loadNextPage()
    }
    
    // MARK: - Setup Methods
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Favorites",
            style: .plain,
            target: self,
            action: #selector(openFavorites)
        )
    }
    
    @objc private func openFavorites() {
        let favoritesVC = FavoritesViewController()
        navigationController?.pushViewController(favoritesVC, animated: true)
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CoinTableViewCell.self, forCellReuseIdentifier: CoinTableViewCell.reuseIdentifier)
        tableView.register(CoinShimmerCell.self, forCellReuseIdentifier: CoinShimmerCell.reuseId)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        // Setup filter segment as table header
        filterSegmentedControl.selectedSegmentIndex = 0
        filterSegmentedControl.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
        filterSegmentedControl.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 44)
        tableView.tableHeaderView = filterSegmentedControl
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Filtering
    @objc private func filterChanged() {
        applySelectedFilter()
    }
    
    private func applySelectedFilter() {
        switch filterSegmentedControl.selectedSegmentIndex {
        case 1: // Sort by highest price
            coins.sort { Double($0.price ?? "0") ?? 0 > Double($1.price ?? "0") ?? 0 }
        case 2: // Sort by best 24h change
            coins.sort { Double($0.change ?? "0") ?? 0 > Double($1.change ?? "0") ?? 0 }
        default: // No filter
            break
        }
        tableView.reloadData()
    }
    
    // MARK: - Pagination / Loading
    func loadNextPage() {
        guard !isLoading, totalCoinsLoaded < 100 else { return }
        
        isLoading = true
        tableView.reloadData()
        
        APIClient.shared.fetchCoins(limit: pageSize, offset: offset) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success(let newCoins):
                    self.coins.append(contentsOf: newCoins)
                    self.totalCoinsLoaded = self.coins.count
                    self.offset += self.pageSize
                case .failure(let err):
                    print("failed to load coins:", err)
                }
                self.tableView.reloadData()
            }
        }
    }

}

// MARK: - UITableView DataSource & Delegate
extension CoinListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isLoading ? 10 : coins.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: CoinShimmerCell.reuseId, for: indexPath) as! CoinShimmerCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CoinTableViewCell.reuseIdentifier, for: indexPath) as! CoinTableViewCell
            let coin = coins[indexPath.row]
            cell.configure(with: coin)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCoin = coins[indexPath.row]
        let detailVC = CoinDetailViewController(uuid: selectedCoin.uuid, name: selectedCoin.name)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // Trigger pagination when nearing bottom
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if contentOffsetY > maxOffset - 200 {
            loadNextPage()
        }
    }
    
    // Swipe to add/remove favorites
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let coin = coins[indexPath.row]
        let isFavorite = FavoriteManager.shared.isFavorite(uuid: coin.uuid)
        
        let starImage = UIImage(systemName: isFavorite ? "star.fill" : "star")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        
        let action = UIContextualAction(style: .normal, title: "") { _, _, completion in
            if isFavorite {
                FavoriteManager.shared.remove(uuid: coin.uuid)
            } else {
                FavoriteManager.shared.add(uuid: coin.uuid)
            }
            completion(true)
            tableView.reloadRows(at: [indexPath], with: .automatic) 
        }
        
        action.image = starImage
        action.backgroundColor = .clear
        
        return UISwipeActionsConfiguration(actions: [action])
    }

}
