//
//  ViewController.swift
//  WeightTracker
//
//  Created by Jesse Alltop on 2/7/17.
//  Copyright © 2017 alltopafiTech. All rights reserved.
//

import UIKit
import Firebase

class LogController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Log"
        self.view.backgroundColor = .white
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Log"
    }
    
}
