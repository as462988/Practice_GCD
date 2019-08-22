//
//  Provider.swift
//  Practice_GCD
//
//  Created by yueh on 2019/8/22.
//  Copyright © 2019 yueh. All rights reserved.
//

import Foundation

typealias Hanlder = (YYResult<DataInfo>) -> Void

class Provider {
    
    let decoder = JSONDecoder()
    
    func fetchDataOfset0(completion: @escaping Hanlder){
        fetchData(request: YYMarketRequest.offset0, completion: completion)
    }
    
    func fetchDataOfset10(completion: @escaping Hanlder){
        fetchData(request: YYMarketRequest.offset10, completion: completion)
    }
    
    func fetchDataOfset20(completion: @escaping Hanlder){
        fetchData(request: YYMarketRequest.offset20, completion: completion)
    }
    
    
    private func fetchData(request: YYMarketRequest,completion: @escaping Hanlder) {
        
        HTTPClient.shared.request(request) { [weak self] (result) in
            
            guard let mySelf = self else {return}
            
            switch result {
                
            case .success(let data):
                
                do{
                    
                    let info = try mySelf.decoder.decode(DataInfo.self, from: data)
                    
                    DispatchQueue.main.async {
                    
                        completion(YYResult.success(info))
                    }
                    
                    
                } catch {
                    
                    completion(YYResult.failure(error))
                    
                }
                
            case .failure(let error):
                
                completion(YYResult.failure(error))
            }
        }
        
    }
    
}
