//
//  EndPointType.swift
//  MVVM Project
//
//  Created by Vishal Wagh on 18/07/23.
//

import Foundation


enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
}

protocol EndPointType {
    var path: String { get }
    var baseURL: String { get }
    var url: URL? { get }
    var method: HTTPMethods { get }
    var body: Encodable? { get }
    var header: [String: String]? { get }
}

/// This for every module which we are using in project
enum EndPointItems {
    case products // module
    case addProduct(product: AddProduct)
}

extension EndPointItems: EndPointType {
    
    var path: String {
        switch self { // self bcz its its extension of EndPointItems and we are using the module end point
        case .products:
            return "products"
        case .addProduct:
            return "products/add"
        }
    }
    
    var baseURL: String {
        switch self {
        case .products:
            return "https://fakestoreapi.com/"
        case .addProduct:
            return "https://dummyjson.com/"
        }
    }
    
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    
    var method: HTTPMethods {
        switch self {
        case .products:
            return .get
        case .addProduct:
            return .post
        }
    }
    
    var body: Encodable? {
        switch self {
        case .products:
            return nil
        case .addProduct(let product):
            return product
        }
    }
    
    var header: [String : String]? {
        APIManager.commonHeader
    }
}

