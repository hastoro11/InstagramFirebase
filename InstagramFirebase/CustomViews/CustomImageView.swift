//
//  Extension+UIImageView.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 08..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
    var identifier: String?
    
    func loadImage(from imageURL: String) {
        guard let url = URL(string: imageURL) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    if self.identifier == url.absoluteString {
                        self.image = UIImage(data: data)
                    }
                }
            }
            }.resume()
    }
}
