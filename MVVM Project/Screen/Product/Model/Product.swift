//
//  Product.swift
//  MVVM Project
//
//  Created by Vishal Wagh on 16/07/23.
//

import Foundation


struct Product: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rate
}

struct Rate: Codable {
    let rate: Double
    let count: Int
}
