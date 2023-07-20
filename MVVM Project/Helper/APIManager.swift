//
//  APIManager.swift
//  MVVM Project
//
//  Created by Vishal Wagh on 16/07/23.
//

import Foundation

enum DataError: Error {
    case invalidResponse
    case invalidURL
    case invalidDecoding
    case message(_ error: Error?)
}

typealias Handler<T> = (Result<T, DataError>) -> Void

// Singleton class
// final - Unable to inheritance the class
final class APIManager {
    static let shared = APIManager()
    private init() {}
    
    func request<T: Codable>(
        modelType: T.Type,
        type: EndPointType,
        completion: @escaping Handler<T>) {
            guard let url = type.url else {
                completion(.failure(.invalidURL))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = type.method.rawValue
            
            if let parameter = type.body {
                request.httpBody = try? JSONEncoder().encode(parameter)
            }
            request.allHTTPHeaderFields = type.header
            
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data, error == nil else {
                    completion(.failure(.invalidResponse))
                    return
                }
                guard let response = response as? HTTPURLResponse, 200 ... 299 ~= response.statusCode else {
                    completion(.failure(.invalidDecoding))
                    return
                }
                
                // JSONDecoder() - Data convert into a model(Array)
                do {
                    let products = try JSONDecoder().decode(modelType, from: data)
                    completion(.success(products))
                }catch {
                    completion(.failure(.message(error)))
                }
            }.resume()
        }
    
    
    static var commonHeader: [String: String] {
        return [
            "Content-Type": "application/json"
        ]
    }
}


/*func fetchProducts(completionHandler: @escaping Handler) {
    guard let url = URL(string: Constant.API.productURL) else {
        completionHandler(.failure(.invalidURL))
        return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data, error == nil else {
            completionHandler(.failure(.invalidResponse))
            return
        }
        guard let response = response as? HTTPURLResponse, 200 ... 299 ~= response.statusCode else {
            completionHandler(.failure(.invalidDecoding))
            return
        }
        
        // JSONDecoder() - Data convert into a model(Array)
        do {
            let products = try JSONDecoder().decode([Product].self, from: data)
            completionHandler(.success(products))
        }catch {
            completionHandler(.failure(.message(error)))
        }
    }.resume()
}*/
