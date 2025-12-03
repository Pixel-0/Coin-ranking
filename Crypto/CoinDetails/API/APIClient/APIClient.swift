//
//  APIClient.swift
//  Crypto
//
//  Created by Sarah Munini Mwangangi on 03/12/2025.
//

import Foundation

final class APIClient {
    
    static let shared = APIClient()
    private init() {}
    
    // MARK: - Generic Request Method
    
    private func performRequest<T: Decodable>(
        path: String,
        queryItems: [URLQueryItem] = [],
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        var components = URLComponents(string: Constants.baseURL + path)!
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            completion(.failure(NSError(domain: "bad_url", code: 0)))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(Constants.apiKey, forHTTPHeaderField: "x-access-token")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "no_data", code: 0)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let apiResponse = try decoder.decode(APIResponse<T>.self, from: data)
                completion(.success(apiResponse.data))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - Coins API
    func fetchCoins(limit: Int, offset: Int, completion: @escaping (Result<[Coin], Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "offset", value: "\(offset)")
        ]
        
        performRequest(path: "/coins", queryItems: queryItems) { (result: Result<CoinsData, Error>) in
            switch result {
            case .success(let coinsData):
                completion(.success(coinsData.coins))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchCoinDetail(uuid: String, completion: @escaping (Result<CoinDetail, Error>) -> Void) {
        performRequest(path: "/coin/\(uuid)") { (result: Result<CoinDetailData, Error>) in
            switch result {
            case .success(let coinDetailData):
                completion(.success(coinDetailData.coin))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchCoinHistory(uuid: String, timePeriod: String = "24h", completion: @escaping (Result<[HistoryPoint], Error>) -> Void) {
        let queryItems = [URLQueryItem(name: "timePeriod", value: timePeriod)]
        performRequest(path: "/coin/\(uuid)/history", queryItems: queryItems, completion: completion)
    }
}
