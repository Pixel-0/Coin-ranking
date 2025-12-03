//
//  Untitled.swift
//  Crypto
//
//  Created by Sarah Munini Mwangangi on 03/12/2025.
//

import SwiftUI

struct SimpleLineChart: View {
    
    let dataPoints: [HistoryPoint]
    
    var body: some View {
        GeometryReader { geometry in
            let prices = dataPoints.compactMap { Double($0.price) }
            let minPrice = prices.min() ?? 0
            let maxPrice = prices.max() ?? 1
            let chartWidth = geometry.size.width
            let chartHeight = geometry.size.height
            
            Path { path in
                for (index, point) in dataPoints.enumerated() {
                    guard let price = Double(point.price) else { continue }
                    
                    let xPosition = chartWidth * CGFloat(index) / CGFloat(max(1, dataPoints.count - 1))
                    
                    let yPosition = chartHeight * (1 - CGFloat((price - minPrice) / (maxPrice - minPrice + 1e-9)))
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    } else {
                        path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                    }
                }
            }
            .stroke(Color.blue, lineWidth: 2)
            .background(Color.clear)
        }
        .padding()
    }
}
