//
//  TabBarController.swift
//  WeightTracker
//
//  Created by Jesse Alltop on 2/23/17.
//  Copyright © 2017 alltopafiTech. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let firstTab = LogController()
        let firstTabItem = UITabBarItem(title: " Log", image: UIImage(named: "iconTab0"), selectedImage: UIImage(named: "iconTab0Filled"))
        
        firstTab.tabBarItem = firstTabItem
        
        
        let secondTab = ProgressGraphController()
        let secondTabItem = UITabBarItem(title: "Progress", image: UIImage(named: "iconTab1"), selectedImage: UIImage(named: "iconTab1Filled"))
        
        secondTab.tabBarItem = secondTabItem
        
        self.viewControllers = [firstTab,secondTab]
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        guard let title = viewController.title else {
            print("no title")
            return
        }
        
        print("selected \(title)")
       
    }
    
    
}


