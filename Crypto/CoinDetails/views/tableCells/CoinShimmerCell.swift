//
//  CoinShimmerCell.swift
//  Crypto
//
//  Created by Sarah Munini Mwangangi on 03/12/2025.
//

import UIKit

class CoinShimmerCell: UITableViewCell {
    static let reuseId = "CoinShimmerCell"
    
    private let iconShimmer = UIView()
    private let nameShimmer = UIView()
    private let priceShimmer = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupShimmers()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupShimmers() {
        [iconShimmer, nameShimmer, priceShimmer].forEach {
            $0.backgroundColor = UIColor.systemGray5
            $0.layer.cornerRadius = 4
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            iconShimmer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconShimmer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconShimmer.widthAnchor.constraint(equalToConstant: 48),
            iconShimmer.heightAnchor.constraint(equalToConstant: 48),
            
            nameShimmer.leadingAnchor.constraint(equalTo: iconShimmer.trailingAnchor, constant: 16),
            nameShimmer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameShimmer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameShimmer.heightAnchor.constraint(equalToConstant: 20),
            
            priceShimmer.leadingAnchor.constraint(equalTo: iconShimmer.trailingAnchor, constant: 16),
            priceShimmer.topAnchor.constraint(equalTo: nameShimmer.bottomAnchor, constant: 8),
            priceShimmer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            priceShimmer.heightAnchor.constraint(equalToConstant: 16),
            
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: priceShimmer.bottomAnchor, constant: 16)
        ])
    }
}

