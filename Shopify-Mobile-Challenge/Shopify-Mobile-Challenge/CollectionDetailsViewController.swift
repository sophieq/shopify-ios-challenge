//
//  CollectionDetailsViewController.swift
//  Shopify-Mobile-Challenge
//
//  Created by Sophie Qin on 2019-01-13.
//  Copyright © 2019 Sophie Qin. All rights reserved.
//

import UIKit

class CollectionDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var collection: Collection?
    var productIDs = [Int]()
    var products = [Product]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = (collection?.name ?? "Collection") + " Details"
        getProductIDs()
        tableView.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "listCell")
        tableView.register(UINib(nibName: "CardTableViewCell", bundle: nil), forCellReuseIdentifier: "cardCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 250

    }
    
    @IBAction func didPressDismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func getProductIDs() {
        var url = "https://shopicruit.myshopify.com/admin/collects.json?collection_id="
        url.append(String(collection!.id))
        url.append("&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6")
        
        let urlRequest = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription)
                print("error in get")
                return
            }
            
            guard let data = data else {
                print("error with data")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String : AnyObject]
                if let collectsFromJSON = json["collects"] as? [[String: AnyObject]]
                {
                    for collectFromJSON in collectsFromJSON {
                        self.productIDs.append((collectFromJSON["product_id"] as? Int)!)
                    }
                }
                self.getProductDetails()
                
            } catch let error {
                print(error)
            }
            
        }
        task.resume()
    }
    
    func getProductDetails() {
        var url = "https://shopicruit.myshopify.com/admin/products.json?ids="
        url.append(String(productIDs[0]))
        for id in productIDs.dropFirst() {
            url.append(",")
            url.append(String(id))
        }
        url.append("&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6")
        
        let urlRequest = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription)
                print("error in get")
                return
            }
            
            guard let data = data else {
                print("error with data")
                return
            }
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String : AnyObject]
                if let productsFromJSON = json["products"] as? [[String: AnyObject]]
                {
                    for productFromJSON in productsFromJSON {
                        var product = Product(name: "", id: 0, quantity: 0)
                        var quantities = 0
                        
                        if let id = productFromJSON["id"] as? Int,
                            let name = productFromJSON["title"] as? String
                        {
                            product.id = id
                            product.name = name
                        }
                        
                        if let variantsArray = productFromJSON["variants"] as? [[String: AnyObject]] {
                            for variant in variantsArray {
                                quantities += variant["inventory_quantity"] as! Int
                            }
                            product.quantity = quantities
                        }
                        self.products.append(product)
                    }
                }
                
                DispatchQueue.main.async {

                    self.tableView.reloadData()
                    self.tableView.separatorInset = UIEdgeInsets.zero
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                }
                
            } catch let error {
                print(error)
            }

        }
        task.resume()
    }
}

extension CollectionDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UITableView.automaticDimension
        }
        return 95
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell") as! CardTableViewCell
            cell.imageCollection.downloadImage(from: (collection?.imageURL)!)
            cell.labelTitle.text = collection?.name
            cell.labelDescription.text = collection?.description
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! ListCell
        cell.labelName.text = products[indexPath.row - 1].name
        cell.labelQuantity.text = "Inventory: " + String(products[indexPath.row - 1].quantity)
        cell.labelCollection.text = collection?.name
        cell.imageCollection.downloadImage(from: (collection?.imageURL)!)

        return cell
    }
}
