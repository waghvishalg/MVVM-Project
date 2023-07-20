//
//  ProdcutListViewController.swift
//  MVVM Project
//
//  Created by Vishal Wagh on 16/07/23.
//

import UIKit

class ProductListViewController: UIViewController {

    @IBOutlet weak var productTableView: UITableView!
    private var viewModel = ProductViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
    
    @IBAction func addProductButtonClick(_ sender: Any) {
        addProduct()
    }
    
    func addProduct() {
        let product = AddProduct(title: "iPhone")
        viewModel.addProduct(parameters: product)
    }
    
}

extension ProductListViewController {
    
    func configuration() {
        productTableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        self.initViewModel()
        self.observerEvents()
    }
    
    func initViewModel() {
        self.viewModel.fetchProduct()
    }
    
    // Data Binding event observer communication
    func observerEvents() {
        self.viewModel.eventHandler = { [weak self]events in
            guard let self else {  return }
            switch events {
                case .startLoading:
                    print("Start Loading:")
                case .stopLoading:
                    print("Stop loading:")
                case .dataLoaded:
                    print("Data Loaded: ",self.viewModel.products)
                    DispatchQueue.main.async {
                        self.productTableView.reloadData()
                    }
                case .error(let error):
                    print("Error:", error ?? "error")
                case .newProductAdded(let product):
                    print("product: ",product)
            }
        }
    }
}

extension ProductListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as? ProductCell else {
            return UITableViewCell()
        }
        
        let product = viewModel.products[indexPath.row]
        cell.product = product
        return cell
    }
}
