//
//  HTTPClient.swift
//  Practice_GCD
//
//  Created by yueh on 2019/8/22.
//  Copyright © 2019 yueh. All rights reserved.
//

import Foundation

enum YYResult<T> {
    
    case success(T)
    
    case failure(Error)
}

enum HTTPClientError: Error {
    
    case decodeDataFail
    
    case clientError(Data)
    
    case serverError
    
    case unexpectedError
}

enum YYHTTPMethod:String {
    case GET
}

protocol YYRequest {
    
    var headers: [String: String] { get }
    
    var body: Data? { get }
    
    var method: String { get }
    
    var endPoint: String { get }
}

extension YYRequest {
    
    func makeRequest() -> URLRequest{
        let urlString = "https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=5012e8ba-5ace-4821-8482-ee07c147fd0a&limit=1" + endPoint
        
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        
        //request.allHTTPHeaderFields = headers
        
        //request.httpBody = body
        
        request.httpMethod = method
        
        return request
    }
    
}

class HTTPClient {
    
    static let shared = HTTPClient()
    
    private let decoder = JSONDecoder()
    
    private init() { }
    
    func request(_ yyRequest: YYRequest, completion: @escaping (YYResult<Data>) -> Void){
        
//        print(yyRequest.makeRequest())
        
        URLSession.shared.dataTask(with: yyRequest.makeRequest()) { (data, response, error) in
           
            guard error == nil else {
                
                return completion(YYResult.failure(error!))
            }
            
            let httpResponse = response as! HTTPURLResponse

            let statusCode = httpResponse.statusCode
            
            switch statusCode {
                
            case 200..<300:

                completion(YYResult.success(data!))
                
            case 400..<500:
                
                completion(YYResult.failure(HTTPClientError.clientError(data!)))
                
            case 500..<600:
                
                completion(YYResult.failure(HTTPClientError.serverError))
                
            default: return
                
                completion(YYResult.failure(HTTPClientError.unexpectedError))
            }
        }.resume()
        
    }
}
