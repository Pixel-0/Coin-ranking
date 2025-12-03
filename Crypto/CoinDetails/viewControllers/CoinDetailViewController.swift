//
//  CoinDetailViewController.swift
//  Crypto
//
//  Created by Sarah Munini Mwangangi on 03/12/2025.
//

import UIKit
import SwiftUI
import Charts

// MARK: - SwiftUI Line Chart
struct CoinLineChartView: View {
    let prices: [Double]

    var body: some View {
        Chart {
            ForEach(prices.indices, id: \.self) { index in
                LineMark(
                    x: .value("Index", index),
                    y: .value("Price", prices[index])
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.blue, Color.blue.opacity(0.2)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

                PointMark(
                    x: .value("Index", index),
                    y: .value("Price", prices[index])
                )
                .foregroundStyle(Color.blue)
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .frame(height: 230)
        .padding(.horizontal)
    }
}

// MARK: - Chart Range Enum
enum ChartRange: CaseIterable {
    case last24h, last7d, last30d

    var displayTitle: String {
        switch self {
        case .last24h: return "24h"
        case .last7d:  return "7d"
        case .last30d: return "30d"
        }
    }
}

// MARK: - Chart Range Selector
struct ChartRangeSelector: View {
    @Binding var selectedRange: ChartRange

    var body: some View {
        HStack(spacing: 20) {
            ForEach(ChartRange.allCases, id: \.self) { range in
                Button(action: { selectedRange = range }) {
                    Text(range.displayTitle)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 14)
                        .background(selectedRange == range ? Color.blue.opacity(0.25) : Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
            }
        }
        .padding(.vertical, 10)
    }
}

// MARK: - Chart Container with Range Selector
struct CoinChartContainer: View {
    let prices: [Double]
    @State private var selectedRange: ChartRange = .last24h

    var body: some View {
        VStack(spacing: 10) {
            ChartRangeSelector(selectedRange: $selectedRange)

            let filteredPrices: [Double] = {
                switch selectedRange {
                case .last24h: return Array(prices.suffix(24))
                case .last7d:  return Array(prices.suffix(24 * 7))
                case .last30d: return Array(prices.suffix(24 * 30))
                }
            }()

            CoinLineChartView(prices: filteredPrices)
        }
    }
}

// MARK: - UIKit Coin Detail Screen
class CoinDetailViewController: UIViewController {

    // MARK: Properties
    private let coinUUID: String
    private let coinName: String

    private var coinDetail: CoinDetail?

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private var chartHostingController: UIHostingController<AnyView>?

    // MARK: - Init
    init(uuid: String, name: String) {
        self.coinUUID = uuid
        self.coinName = name
        super.init(nibName: nil, bundle: nil)
        self.title = name
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        loadCoinDetail()
    }
}

// MARK: - UI Setup
private extension CoinDetailViewController {

    func setupUI() {
        setupScrollView()
        setupContentStack()
        setupLabels()
    }

    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupContentStack() {
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

    func setupLabels() {
        nameLabel.font = .boldSystemFont(ofSize: 32)
        nameLabel.textAlignment = .center
        contentStack.addArrangedSubview(nameLabel)

        priceLabel.font = .systemFont(ofSize: 26, weight: .medium)
        priceLabel.textAlignment = .center
        contentStack.addArrangedSubview(priceLabel)
    }
}

// MARK: - Load Coin Data
private extension CoinDetailViewController {

    func loadCoinDetail() {
        APIClient.shared.fetchCoinDetail(uuid: coinUUID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detail):
                    self?.coinDetail = detail
                    self?.populateUI(with: detail)
                case .failure(let error):
                    print("Error loading coin detail:", error)
                }
            }
        }
    }

    func populateUI(with coin: CoinDetail) {
        nameLabel.text = coin.name
        priceLabel.text = "$" + (coin.price ?? "-")

        addChartSection()
        addStatsSection(for: coin)
    }
}

// MARK: - Chart Section
private extension CoinDetailViewController {

    func addChartSection() {
        guard let sparkline = coinDetail?.sparkline?.compactMap({ Double($0) }), !sparkline.isEmpty else { return }

        let chartContainer = CoinChartContainer(prices: sparkline)
        let hostingController = UIHostingController(rootView: AnyView(chartContainer))
        chartHostingController = hostingController

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(hostingController.view)
        hostingController.view.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
}

// MARK: - Stats Section
private extension CoinDetailViewController {

    func addStatsSection(for coin: CoinDetail) {
        let statsStack = UIStackView()
        statsStack.axis = .vertical
        statsStack.spacing = 8
        statsStack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
        statsStack.isLayoutMarginsRelativeArrangement = true

        func makeStatLabel(title: String, value: String?) -> UILabel {
            let label = UILabel()
            label.text = "\(title): \(value ?? "-")"
            label.font = .systemFont(ofSize: 16)
            return label
        }

        statsStack.addArrangedSubview(makeStatLabel(title: "Market Cap", value: coin.marketCap))
        statsStack.addArrangedSubview(makeStatLabel(title: "24h Volume", value: coin.volume24h))
        statsStack.addArrangedSubview(makeStatLabel(title: "Circulating Supply", value: coin.supply?.circulating))
        statsStack.addArrangedSubview(makeStatLabel(title: "Max Supply", value: coin.supply?.total))
        statsStack.addArrangedSubview(makeStatLabel(title: "All-Time High", value: coin.allTimeHigh?.price))

        contentStack.addArrangedSubview(statsStack)
    }
}
