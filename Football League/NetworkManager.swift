//
//  NetworkManager.swift
//  Football League
//
//  Created by Arabia-IT on 11/18/18.
//  Copyright © 2018 Arabia-IT. All rights reserved.
//

import Foundation

class NetworkManager {
    static let shared =  NetworkManager.init()
    private init() {}
    typealias completionType = ((Decodable)->())
    typealias errorType = ((Error?)->())
    
    func fetchData<T>(withUrlRequest urlRequest: URLRequest,  andResponceType responceType: T.Type, andCompletion completion: @escaping completionType , andErrorHandler errorHandler: @escaping errorType ) where T : Decodable {
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response
            , error) in
            if  error != nil  {
                DispatchQueue.main.async {
                    errorHandler(error)
                }
            }
            else {
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let result  = try decoder.decode(responceType, from: data)
                        DispatchQueue.main.async {
                            completion(result)
                        }
                        
                    } catch {
                        DispatchQueue.main.async {
                            print(error)
                            errorHandler(error)
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        errorHandler(error)
                    }
                }
            }
            
        }
        
        task.resume()
    }
    
}




