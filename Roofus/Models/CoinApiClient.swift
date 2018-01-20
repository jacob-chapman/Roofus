//
//  ApiClient.swift
//  Roofus
//
//  Created by Jacob Chapman on 1/17/18.
//  Copyright © 2018 AireCodes. All rights reserved.
//

import Foundation

//Object to handle getting the data from CoinAPI
//Separate out into base class later when introducing more apis
class CoinApiClient : ApiClientProtocol {
    
    
    var baseEndPoint: String
    var apiKey: String?
    
    init(){
        self.baseEndPoint = ApiPaths.coinApiPath
        self.apiKey = ApiKeys.coinApiKey
    }
    
    public func getExchanges(){
        
        let urlString = URL(string:  addApiKey(withUrl: baseEndPoint + CoinApiMetadata.exchange.rawValue))
        
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error)
                } else {
                    if let usableData = data {
                        print(usableData) //JSONSerialization
                        let json = try? JSONSerialization.jsonObject(with: usableData, options: [])
                        print(json)
                    }
                }
            }
            task.resume()
        }
        
    }
    
    
    internal func addApiKey(withUrl urlString : String) -> String {
        return urlString + "?apiKey=" + apiKey!
    }
    
}


enum CoinApiMetadata : String {
    case exchange = "exchanges"
    case assets = "assets"
    case symbols = "symbols"
    case exchangeRate = "exchangerate"
}
