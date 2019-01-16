//
//  CustomCollectionViewController.swift
//  Shopify-Mobile-Challenge
//
//  Created by Sophie Qin on 2019-01-12.
//  Copyright © 2019 Sophie Qin. All rights reserved.
//

import UIKit

class CustomCollectionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var collections = [Collection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCollections()
        
        tableView.register(UINib(nibName: "CustomCollectionCell", bundle: nil), forCellReuseIdentifier: "customCollectionCell")
        
    }
    
    func getCollections() {
        let urlRequest = URLRequest(url: URL(string: "https://shopicruit.myshopify.com/admin/custom_collections.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6")!)
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
                if let collectionsFromJSON = json["custom_collections"] as? [[String: AnyObject]]
                {
                    for collectionFromJSON in collectionsFromJSON {
                        var collection = Collection(name: "", id: 0, product_ids: [], imageURL: "")
                        
                        if let name = collectionFromJSON["title"] as? String,
                            let id = collectionFromJSON["id"] as? Int,
                            let imageURL = collectionFromJSON["image"]?["src"] as? String
                        {
                            collection.name = name
                            collection.id = id
                            collection.imageURL = imageURL
                        }
                        self.collections.append(collection)
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

extension CustomCollectionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCollectionCell") as! CustomCollectionCell
        cell.labelName.text = collections[indexPath.row].name
        cell.imageCollection.downloadImage(from: (collections[indexPath.row].imageURL))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CollectionDetailsViewController()
        vc.collection = collections[indexPath.row]
        present(vc, animated: true, completion: nil)
    }
}
