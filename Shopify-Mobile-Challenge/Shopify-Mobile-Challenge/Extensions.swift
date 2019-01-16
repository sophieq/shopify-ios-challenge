//
//  Extensions.swift
//  Shopify-Mobile-Challenge
//
//  Created by Sophie Qin on 2019-01-16.
//  Copyright © 2019 Sophie Qin. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func downloadImage(from url: String) {
        let urlRequest = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print("error downloading image")
                return
            }
            
            guard let data = data else {
                print("data not found")
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
            
        }
        task.resume()
    }
}
