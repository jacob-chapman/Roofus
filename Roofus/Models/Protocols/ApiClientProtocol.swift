//
//  ApiClientProtocol.swift
//  Roofus
//
//  Created by Jacob Chapman on 1/19/18.
//  Copyright © 2018 AireCodes. All rights reserved.
//

import Foundation


protocol ApiClientProtocol {
    
    var baseEndPoint : String { get }
    
    var apiKey : String? { get }
}
