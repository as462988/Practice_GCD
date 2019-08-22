//
//  Data.swift
//  Practice_GCD
//
//  Created by yueh on 2019/8/22.
//  Copyright © 2019 yueh. All rights reserved.
//

import Foundation

struct DataInfo: Codable {
    let result: Result
}

struct Result:Codable {
    let results: [Results]
}

struct Results:Codable {
 
    let speedLimit: String
   
    let road:String
    
    enum CodingKeys: String,CodingKey {
        case speedLimit = "speed_limit"
        case road
        
    }
}
