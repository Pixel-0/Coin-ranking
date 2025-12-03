//
//  CoinDetailShimmerView.swift
//  Crypto
//
//  Created by Sarah Munini Mwangangi on 03/12/2025.
//


import UIKit

class CoinDetailShimmerView: UIView {
    
    private let iconShimmer = UIView()
    private let nameShimmer = UIView()
    private let priceShimmer = UIView()
    private let statsShimmer = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShimmers()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupShimmers() {
        backgroundColor = .systemBackground
        
        [iconShimmer, nameShimmer, priceShimmer, statsShimmer].forEach {
            $0.backgroundColor = UIColor.systemGray5
            $0.layer.cornerRadius = 6
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            iconShimmer.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            iconShimmer.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconShimmer.widthAnchor.constraint(equalToConstant: 80),
            iconShimmer.heightAnchor.constraint(equalToConstant: 80),
            
            nameShimmer.topAnchor.constraint(equalTo: iconShimmer.bottomAnchor, constant: 16),
            nameShimmer.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameShimmer.widthAnchor.constraint(equalToConstant: 180),
            nameShimmer.heightAnchor.constraint(equalToConstant: 24),
            
            priceShimmer.topAnchor.constraint(equalTo: nameShimmer.bottomAnchor, constant: 12),
            priceShimmer.centerXAnchor.constraint(equalTo: centerXAnchor),
            priceShimmer.widthAnchor.constraint(equalToConstant: 120),
            priceShimmer.heightAnchor.constraint(equalToConstant: 20),
            
            statsShimmer.topAnchor.constraint(equalTo: priceShimmer.bottomAnchor, constant: 20),
            statsShimmer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            statsShimmer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            statsShimmer.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
