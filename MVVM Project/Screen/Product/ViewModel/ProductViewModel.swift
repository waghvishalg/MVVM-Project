//
//  ProductViewModel.swift
//  MVVM Project
//
//  Created by Vishal Wagh on 16/07/23.
//

import Foundation


final class ProductViewModel {
    
    var products: [Product] = []
    var eventHandler: ((_ event: Events) -> Void)? // Data Binding closure
    
    
    func fetchProduct() {
        self.eventHandler?(.startLoading)
        APIManager.shared.request(
            modelType: [Product].self,
            type: EndPointItems.products) { response in
                self.eventHandler?(.stopLoading)
                switch response {
                case .success(let products):
                    self.products = products
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                }
            }
    }
    
    
    func addProduct(parameters: AddProduct) {
        self.eventHandler?(.startLoading)
        APIManager.shared.request(
            modelType: AddProduct.self,
            type: EndPointItems.addProduct(product: parameters)) { result in
                self.eventHandler?(.stopLoading)
                switch result {
                case .success(let product):
                    self.eventHandler?(.newProductAdded(product: product))
                case .failure(let error):
                    self.eventHandler?(.error(error))
                }
            }
    }
}

extension ProductViewModel {
    
    enum Events {
        case startLoading
        case stopLoading
        case dataLoaded
        case error(Error?)
        case newProductAdded(product: AddProduct)
    }
}
