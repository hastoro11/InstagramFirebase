//
//  MainController.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 06..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import UIKit

class MainController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupViews()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let index = viewControllers?.firstIndex(of: viewController) else {return true}
        if index == 2 {
            let photoController = PhotoController(collectionViewLayout: UICollectionViewFlowLayout())
            present(UINavigationController(rootViewController: photoController), animated: true)
            return false
        }
        return true
    }
    
    fileprivate func setupViews() {
        //home
        let homeController = HomeController(collectionViewLayout: UICollectionViewFlowLayout())
        homeController.tabBarItem.image = UIImage(named: "home_unselected")
        homeController.tabBarItem.selectedImage = UIImage(named: "home_selected")
        
        //search
        let searchController = SearchController()
        searchController.tabBarItem.image = UIImage(named: "search_unselected")
        searchController.tabBarItem.selectedImage = UIImage(named: "search_selected")
        
        //photo
        let photoController = UIViewController()
        photoController.tabBarItem.image = UIImage(named: "plus_unselected")
        photoController.tabBarItem.selectedImage = UIImage(named: "plus_unselected")
        
        //like
        let likeController = UITableViewController()
        likeController.tabBarItem.image = UIImage(named: "like_unselected")
        likeController.tabBarItem.selectedImage = UIImage(named: "like_selected")
        
        //profile
        let profileController = ProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
        profileController.tabBarItem.selectedImage = UIImage(named: "profile_selected")
        profileController.tabBarItem.image = UIImage(named: "profile_unselected")
        
        //tabbars
        viewControllers = [
            UINavigationController(rootViewController: homeController),
            UINavigationController(rootViewController: searchController),
            photoController,
            UINavigationController(rootViewController: likeController),
            UINavigationController(rootViewController: profileController)
        ]
    }
}
