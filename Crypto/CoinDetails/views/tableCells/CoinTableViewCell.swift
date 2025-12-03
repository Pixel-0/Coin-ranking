//
//  CoinTableViewCell.swift
//  Crypto
//
//  Created by Sarah Munini Mwangangi on 03/12/2025.
//

import UIKit

class CoinTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "CoinCell"
    
    // MARK: - UI Elements
    private let coinIconImageView = UIImageView()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let changeLabel = UILabel()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Coin Icon
        coinIconImageView.translatesAutoresizingMaskIntoConstraints = false
        coinIconImageView.layer.cornerRadius = 20
        coinIconImageView.clipsToBounds = true
        coinIconImageView.contentMode = .scaleAspectFit
        contentView.addSubview(coinIconImageView)
        
        // Name Label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        contentView.addSubview(nameLabel)
        
        // Price Label
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(priceLabel)
        
        // Change Label
        changeLabel.translatesAutoresizingMaskIntoConstraints = false
        changeLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(changeLabel)
        
        // Constraints
        NSLayoutConstraint.activate([
            coinIconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            coinIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            coinIconImageView.widthAnchor.constraint(equalToConstant: 40),
            coinIconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            nameLabel.leadingAnchor.constraint(equalTo: coinIconImageView.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            changeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            changeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    // MARK: - Configure Cell
    func configure(with coin: Coin) {
        populateUI(name: coin.name, price: coin.price, change: coin.change, iconUrl: coin.iconUrl)
    }
    
    func configure(with coinViewModel: CoinViewModel) {
        populateUI(name: coinViewModel.name, price: coinViewModel.price, change: coinViewModel.change, iconUrl: coinViewModel.iconUrl)
    }
    
    // MARK: - Private Helper
    private func populateUI(name: String, price: String?, change: String?, iconUrl: String?) {
        nameLabel.text = name
        
        if let priceStr = price, let priceValue = Double(priceStr) {
            priceLabel.text = String(format: "$%.2f", priceValue)
        } else {
            priceLabel.text = "-"
        }
        
        if let changeStr = change, let changeValue = Double(changeStr) {
            changeLabel.text = String(format: "%+.2f%%", changeValue)
            changeLabel.textColor = changeValue >= 0 ? .systemGreen : .systemRed
        } else {
            changeLabel.text = "-"
            changeLabel.textColor = .label
        }
        
        coinIconImageView.image = UIImage(systemName: "bitcoinsign.circle")
        
        // Load icon asynchronously
        if let urlString = iconUrl, let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let self = self, let data = data, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.coinIconImageView.image = image
                }
            }.resume()
        }
    }
}
