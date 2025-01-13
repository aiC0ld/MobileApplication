//
//  TabBarController.swift
//  FinalProject_35
//
//  Created by Yu huiying on 12/2/24.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Tab for Profile
        let tabProfile = UINavigationController(
            rootViewController: ProfileViewController()
        )
        let tabProfileItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.crop.circle"),
            selectedImage: UIImage(systemName: "person.crop.circle.fill")
        )
        tabProfile.tabBarItem = tabProfileItem
        tabProfile.title = "Profile"
        
        // Tab for Posts
        let tabPost = UINavigationController(
            rootViewController: PostViewController()
        )
        let tabPostItem = UITabBarItem(
            title: "Post",
            image: UIImage(systemName: "plus.circle"),
            selectedImage: UIImage(systemName: "plus.circle.fill")
        )
        tabPost.tabBarItem = tabPostItem
        tabPost.title = "Post"
        
        // Tab for Home
        let tabMain = UINavigationController(
            rootViewController: MainViewController()
        )
        let tabMainItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        tabMain.tabBarItem = tabMainItem
        tabMain.title = "Home"
        
        self.viewControllers = [tabMain, tabPost, tabProfile]
        

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
   
}
