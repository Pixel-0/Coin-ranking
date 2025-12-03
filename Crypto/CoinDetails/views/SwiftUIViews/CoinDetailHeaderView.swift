//
//  SwiftUIViews.swift
//  Crypto
//
//  Created by Sarah Munini Mwangangi on 03/12/2025.
//

import SwiftUI

struct CoinDetailHeaderView: View {
    
    let coinDetail: CoinDetail
    
    var body: some View {
        HStack(spacing: 12) {
            
            // Coin Icon
            AsyncImage(url: URL(string: coinDetail.iconUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            // Coin Name and Stats
            VStack(alignment: .leading, spacing: 4) {
                Text(coinDetail.name)
                    .font(.title2)
                    .bold()
                
                if let priceString = coinDetail.price, let price = Double(priceString) {
                    Text(String(format: "$%.2f", price))
                        .font(.title3)
                }
                
                if let changeString = coinDetail.change, let change = Double(changeString) {
                    Text(String(format: "%+.2f%% (24h)", change))
                        .font(.subheadline)
                        .foregroundColor(change >= 0 ? .green : .red)
                }
            }
            
            Spacer()
        }
        .padding()
    }
}
