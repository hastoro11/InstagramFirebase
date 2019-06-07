//
//  MainController.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 06..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import UIKit

class MainController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    fileprivate func setupViews() {
        
        
        //profile
        let profileController = ProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
        profileController.tabBarItem.selectedImage = UIImage(named: "profile_selected")
        profileController.tabBarItem.image = UIImage(named: "profile_selected")
        viewControllers = [UINavigationController(rootViewController: profileController)]
    }
}
