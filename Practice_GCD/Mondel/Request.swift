//
//  Request.swift
//  Practice_GCD
//
//  Created by yueh on 2019/8/22.
//  Copyright © 2019 yueh. All rights reserved.
//

import Foundation


enum YYMarketRequest: YYRequest {
 
    case offset0
    
    case offset10
    
    case offset20
    
    var headers: [String : String] {
        
        switch self {
        case .offset0, .offset10, .offset20: return [:]
        }
    }
    
    var body: Data? {
        
        switch self {
        case .offset0, .offset10, .offset20: return nil
        }
    }
    
    var method: String {
        
        switch self {
        case .offset0, .offset10, .offset20: return YYHTTPMethod.GET.rawValue
        }
    }
    
    var endPoint: String {
        
        switch self {
        case .offset0: return "&offset=0"
        case .offset10: return "&offset=10"
        case .offset20: return "&offset=20"
            
        }
    }
}
