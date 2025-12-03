//
//  Models.swift
//  Crypto
//
//  Created by Sarah Munini Mwangangi on 03/12/2025.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
    let status: String
    let data: T
}

struct CoinsData: Decodable {
    let stats: Stats
    let coins: [Coin]
    let pagination: Pagination
}

struct Stats: Decodable {
    let total: Int
    let totalCoins: Int
    let totalMarkets: Int
    let totalExchanges: Int
    let totalMarketCap: String
    let total24hVolume: String
}

struct Pagination: Decodable {
    let limit: Int
    let hasNextPage: Bool
    let nextCursor: String
}

struct Coin: Decodable {
    let uuid: String
    let symbol: String
    let name: String
    let color: String?
    let iconUrl: String?
    let marketCap: String?
    let price: String?
    let change: String?
    let listedAt: Int?
    let tier: Int?
    let rank: Int?
    let sparkline: [String]?
    let lowVolume: Bool?
    let coinrankingUrl: String?
    let btcPrice: String?
    let contractAddresses: [String]?
    let isWrappedTrustless: Bool?
    let wrappedTo: String?
    let _24hVolume: String?
    
    enum CodingKeys: String, CodingKey {
        case uuid, symbol, name, color, iconUrl, marketCap, price, change, listedAt, tier, rank, sparkline, lowVolume, coinrankingUrl, btcPrice, contractAddresses, isWrappedTrustless, wrappedTo
        case _24hVolume = "24hVolume"
    }
}

struct CoinViewModel {
    let uuid: String
    let symbol: String
    let name: String
    let price: String?
    let change: String?
    let iconUrl: String?
}

struct CoinDetailData: Decodable {
    let coin: CoinDetail
}


struct CoinDetail: Decodable {
    let uuid: String
    let symbol: String?
    let name: String
    let description: String?
    let color: String?
    let iconUrl: String?
    let websiteUrl: String?
    let links: [Link]?
    let supply: Supply?
    let price: String?
    let change: String?
    let marketCap: String?
    let volume24h: String?
    let sparkline: [String]?
    let allTimeHigh: AllTimeHigh?
    let tier: Int?
    let lowVolume: Bool?
    let listedAt: Int?
    let btcPrice: String?
    let contractAddresses: [String]?
    let isWrappedTrustless: Bool?
    let wrappedTo: String?
    
    enum CodingKeys: String, CodingKey {
        case uuid, symbol, name, description, color, iconUrl, websiteUrl, links, supply, price, change, sparkline, allTimeHigh, tier, lowVolume, listedAt, btcPrice, contractAddresses, isWrappedTrustless, wrappedTo
        case marketCap
        case volume24h = "24hVolume"
    }
}

struct Link: Decodable {
    let name: String
    let url: String
    let type: String
}

struct Supply: Decodable {
    let confirmed: Bool
    let supplyAt: Int?
    let max: String?
    let total: String?
    let circulating: String?
}

struct AllTimeHigh: Decodable {
    let price: String?
    let timestamp: Int?
}


struct HistoryPoint: Decodable {
    let price: String
    let timestamp: Int
}

struct HistoryData: Decodable {
    let history: [HistoryPoint]
}

struct PricePoint: Identifiable, Codable {
    let id = UUID()
    let timestamp: Double
    let price: Double
}


struct CoinDetailResponse: Decodable {
    let status: String
    let data: CoinDetailData
}

struct CoinLink: Decodable {
    let name: String
    let url: String
    let type: String
}

struct CoinSupply: Decodable {
    let confirmed: Bool
    let supplyAt: Int
    let max: String?
    let total: String?
    let circulating: String?
}

