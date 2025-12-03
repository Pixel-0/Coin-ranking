//
//  LineChartView.swift
//  Crypto
//
//  Created by Sarah Munini Mwangangi on 03/12/2025.
//

import SwiftUI
import Charts

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
