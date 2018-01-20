//
//  CoinMarketApiClient.swift
//  Roofus
//
//  Created by Jacob Chapman on 1/19/18.
//  Copyright © 2018 AireCodes. All rights reserved.
//

import Foundation


class MarketApiClient : ApiClientProtocol {
    
    var baseEndPoint: String
    var apiKey: String?
    
    init(){
        self.baseEndPoint = ApiPaths.coinMarketApiPath
        self.apiKey = nil
    }

    public func getTicker(){
        let urlString = URL(string: baseEndPoint + CoinMarketMetadata.ticker.rawValue)

        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                var currencies: [Ticker] = []
                
                if let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    for case let result in json! {
                        if let currency = Ticker(json: result) {
                            currencies.append(currency)
                        }
                    }
                }
            }
            
            task.resume()
        }
    }
}


struct Ticker {
    
    init?(json: [String: Any]){
        
        guard let name = json["name"] as? String,
            let symbol = json["symbol"] as? String,
            let totalSupply = json["total_supply"] as? String,
            let priceUSD = json["price_usd"] as? String,
            let priceBTC = json["price_btc"] as? String
        else {
            //error
            return nil
        }
        
        self.name = name
        self.symbol = symbol
        self.totalSupply = totalSupply
        self.priceBTC = priceBTC
        self.priceUSD = priceUSD
    }
    
    let symbol : String
    let totalSupply : String
    let priceUSD : String
    let priceBTC : String
    let name : String
 
    
    static func tickers(with apiClient: MarketApiClient, completion: @escaping ([Ticker]) -> Void){
    
        let urlString = URL(string: apiClient.baseEndPoint + CoinMarketMetadata.ticker.rawValue)
        
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                var currencies: [Ticker] = []
                
                if let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    for case let result in json! {
                        if let currency = Ticker(json: result) {
                            currencies.append(currency)
                        }
                    }
                }
                
                completion(currencies)
            }
            task.resume()
        }
    }
    
}

enum CoinMarketMetadata : String {
    case ticker = "ticker"
    case global = "global"
}
