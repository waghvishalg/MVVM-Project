//
//  AddProductViewController.swift
//  MVVM Project
//
//  Created by Vishal Wagh on 18/07/23.
//

import UIKit

struct AddProduct: Codable {
    var id: Int? = nil
    let title: String
}

//struct ProductResponse: Decodable {
//    var id: Int
//    var title: String
//}

class AddProductViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addProduct()
    }
    
    @IBAction func addProductButtonClick(_ sender: Any) {
        
    }
    
    func addProduct() {
        guard let url = URL(string: "https://dummyjson.com/products/add") else {  return }
        
        let parameters = AddProduct(title: "BMW Car")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //Convert module to data using encoder
        request.httpBody = try? JSONEncoder().encode(parameters)
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json"
        ]
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data else { return }
            do {
                // Data to model convert - JSONDecoder + decodable
                let productResponse = try JSONDecoder().decode(AddProduct.self, from: data)
                print("ProductResponse: ", productResponse)
            } catch {
                print("Error: ", error)
            }
        }.resume()
    }
}
