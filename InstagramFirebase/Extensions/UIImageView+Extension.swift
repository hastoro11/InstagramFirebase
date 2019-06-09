//
//  UIImageView+Extension.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 09..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

extension UIImageView {
    func loadImage(from imageURL: String) {
        if let image = imageCache[imageURL] {
            self.image = image
            return
        }
        guard let url = URL(string: imageURL) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                imageCache[imageURL] = UIImage(data: data)
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
            }.resume()
    }
}
