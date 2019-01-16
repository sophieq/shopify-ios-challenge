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
        getProductIDs()
        
        tableView.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "listCell")
        
    }
    
    @IBAction func didPressDismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func getProductIDs() {
        var url = "https://shopicruit.myshopify.com/admin/collects.json?collection_id="
        url.append(String(collection!.id))
        url.append("&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6")
        
        print(url)
        
        
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
                        print(collectFromJSON["product_id"])
                        self.productIDs.append((collectFromJSON["product_id"] as? Int)!)
                    }
                }
                self.getProductDetails()

//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                    self.tableView.separatorInset = UIEdgeInsets.zero
//                    self.tableView.delegate = self
//                    self.tableView.dataSource = self
//                }
                
            } catch let error {
                print(error)
            }
            
        }
        task.resume()
    }
    
    func getProductDetails() {
        var url = "https://shopicruit.myshopify.com/admin/products.json?ids="
        url.append(String(productIDs[0]))
        for id in productIDs {
            if id == productIDs[0] {
                continue
            }
            url.append(",")
            url.append(String(id))
        }
        url.append("&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6")
        
        let urlRequest = URLRequest(url: URL(string: url)!)
        let taskA = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
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
                
                print("got json")
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String : AnyObject]
                if let productsFromJSON = json["products"] as? [[String: AnyObject]]
                {
                    for productFromJSON in productsFromJSON {
                        var product = Product(name: "", id: 0, quantity: 0)
                        var quantities = 0
                        
                        if let id = productFromJSON["id"] as? Int,
                            let name = productFromJSON["title"] as? String
                        {
                            print(name)
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

        }.resume()
    }
}

extension CollectionDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(products.count)
        return products.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! ListCell
        cell.labelName.text = products[indexPath.row].name
        cell.labelQuantity.text = String(products[indexPath.row].quantity)
        cell.labelCollection.text = collection?.name
        cell.imageCollection.downloadImage(from: (collection?.imageURL)!)

        return cell
    }
}
