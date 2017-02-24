//
//  TabBarController2.swift
//  WeightTracker
//
//  Created by Jesse Alltop on 2/23/17.
//  Copyright © 2017 alltopafiTech. All rights reserved.
//


import UIKit
import Firebase

class ProgressGraphController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Progress"
        view.backgroundColor = .red
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Progress"

    }
}
