//
//  CoinDetailViewController.swift
//  Crypto
//
//  Created by Sarah Munini Mwangangi on 03/12/2025.
//

import UIKit
import SwiftUI
import Charts

class CoinDetailViewController: UIViewController {

    private let coinUUID: String
    private let coinName: String

    private var coinDetail: CoinDetail?

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let shimmerView = CoinDetailShimmerView()
    private var chartHostingController: UIHostingController<AnyView>?

    init(uuid: String, name: String) {
        self.coinUUID = uuid
        self.coinName = name
        super.init(nibName: nil, bundle: nil)
        self.title = name
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupShimmer()
        loadCoinDetail()
    }

    private func setupShimmer() {
        shimmerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(shimmerView)
        NSLayoutConstraint.activate([
            shimmerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            shimmerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shimmerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shimmerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func loadCoinDetail() {
        APIClient.shared.fetchCoinDetail(uuid: coinUUID) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.shimmerView.removeFromSuperview()
                
                switch result {
                case .success(let detail):
                    self.coinDetail = detail
                    self.setupUI(with: detail)
                case .failure(let error):
                    print("Detail load error:", error)
                    
                }
            }
        }
    }

    private func setupUI(with coin: CoinDetail) {
        setupScrollView()
        setupContentStack()
        setupLabels(with: coin)
        addChartSection()
        addStatsSection(for: coin)
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupContentStack() {
        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func setupLabels(with coin: CoinDetail) {
        let nameLabel = UILabel()
        nameLabel.font = .boldSystemFont(ofSize: 32)
        nameLabel.textAlignment = .center
        nameLabel.text = coin.name
        contentStack.addArrangedSubview(nameLabel)

        let priceLabel = UILabel()
        priceLabel.font = .systemFont(ofSize: 26, weight: .medium)
        priceLabel.textAlignment = .center
        priceLabel.text = "$" + (coin.price ?? "-")
        contentStack.addArrangedSubview(priceLabel)
    }

    private func addChartSection() {
        guard let sparkline = coinDetail?.sparkline?.compactMap({ Double($0) }), !sparkline.isEmpty else { return }
        let chartContainer = CoinChartContainer(prices: sparkline)
        let hostingController = UIHostingController(rootView: AnyView(chartContainer))
        chartHostingController = hostingController
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(hostingController.view)
        hostingController.view.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }

    private func addStatsSection(for coin: CoinDetail) {
        let statsStack = UIStackView()
        statsStack.axis = .vertical
        statsStack.spacing = 16
        statsStack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        statsStack.isLayoutMarginsRelativeArrangement = true
        contentStack.addArrangedSubview(statsStack)
        
        // Helper: create a stat row with title + value, modern flat style
        func makeStatRow(title: String, value: String?, accentColor: UIColor? = nil) -> UIStackView {
            let row = UIStackView()
            row.axis = .horizontal
            row.distribution = .equalSpacing
            row.alignment = .center
            
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
            titleLabel.textColor = .secondaryLabel
            
            let valueLabel = UILabel()
            valueLabel.text = value ?? "-"
            valueLabel.font = .systemFont(ofSize: 18, weight: .bold)
            valueLabel.textColor = accentColor ?? .label
            
            row.addArrangedSubview(titleLabel)
            row.addArrangedSubview(valueLabel)
            return row
        }
        
        // Add a thin separator between rows
        func makeSeparator() -> UIView {
            let line = UIView()
            line.backgroundColor = UIColor.systemGray5
            line.translatesAutoresizingMaskIntoConstraints = false
            line.heightAnchor.constraint(equalToConstant: 1).isActive = true
            return line
        }
        
        statsStack.addArrangedSubview(makeStatRow(title: "Market Cap", value: coin.marketCap))
        statsStack.addArrangedSubview(makeSeparator())
        
        statsStack.addArrangedSubview(makeStatRow(title: "24h Volume", value: coin.volume24h))
        statsStack.addArrangedSubview(makeSeparator())
        
        statsStack.addArrangedSubview(makeStatRow(title: "Circulating Supply", value: coin.supply?.circulating))
        statsStack.addArrangedSubview(makeSeparator())
        
        statsStack.addArrangedSubview(makeStatRow(title: "Max Supply", value: coin.supply?.total))
        statsStack.addArrangedSubview(makeSeparator())
        
        statsStack.addArrangedSubview(makeStatRow(title: "All-Time High", value: coin.allTimeHigh?.price, accentColor: .systemGreen))
    }
}
