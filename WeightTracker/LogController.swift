//
//  ViewController.swift
//  WeightTracker
//
//  Created by Jesse Alltop on 2/7/17.
//  Copyright © 2017 alltopafiTech. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LogController: UITableViewController {
    
    let backgroundColor: UIColor = UIColor(red: 58/255, green: 245/255, blue: 170/255, alpha: 1)
    let negColor: UIColor = UIColor(red: 236/255, green: 29/255, blue: 56/255, alpha: 0.5)
    let posColor: UIColor = UIColor(red: 39/255, green: 219/255, blue: 57/255, alpha: 0.5)
    let cellId = "cellId"
    private var array = [WeightEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Log"
        self.view.backgroundColor = .clear
        
        tableView.register(CustomWeightCell.self, forCellReuseIdentifier: cellId)
        
        let gradient = CAGradientLayer()
        gradient.frame = self.tableView.bounds
        let backgroundView = UIView(frame: self.tableView.bounds)
        gradient.colors = [UIColor(red: 82/255, green: 245/255, blue: 76/255, alpha: 1).cgColor, UIColor(red: 58/255, green: 245/255, blue: 170/255, alpha: 1).cgColor, UIColor.black.cgColor]

        backgroundView.layer.insertSublayer(gradient, at: 0)
        self.tableView.backgroundView = backgroundView
        
        let height = self.navigationController!.navigationBar.frame.height
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        
        buildArrayFromDatabase()
        
    }
    
    func buildArrayFromDatabase() {
        
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        
        let ref = FIRDatabase.database().reference().child("users").child(uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as! String

            ref.child("weightLog").observe(.value, with: { snapshot in
                for child in snapshot.children {
                    
                    
                    let values = (child as! FIRDataSnapshot).value as? NSDictionary

                    let date = values?["date"] as! String
                    let time = values?["time"] as! String
                    let weight = values?["weight"] as! String
                    let key = (child as! FIRDataSnapshot).key
                    let weightChange = values?["weightChange"] as! String

                    self.array.insert(WeightEntry(name: name, date: date, time: time, weight: weight, key: key, weightChange: weightChange),at: 0)
                    
                    
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
            })
            
        })
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Log"
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "add", style: .plain, target: self, action: #selector(addWeightButtonHandler))
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CustomWeightCell(style: .default, reuseIdentifier: cellId)
        cell.textLabel?.text = array[indexPath.row].date
        cell.detailTextLabel?.text = array[indexPath.row].time
        cell.weightView.text = array[indexPath.row].weight + " lbs"
        cell.backgroundColor = .clear
        cell.weightView.backgroundColor = .clear
        cell.weightChangeTextView.text = array[indexPath.row].weightChange
        
        if let weightChange = Double(array[indexPath.row].weightChange) {
            if weightChange != 0.0 {
                if weightChange > 0.0 {
                    cell.arrowImageView.image = #imageLiteral(resourceName: "greenArrow")
                }else {
                    cell.arrowImageView.image = #imageLiteral(resourceName: "redArrow")
                }
            }
        }
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("name: \(array[indexPath.row].name) \ndate: \(array[indexPath.row].date) \ntime: \(array[indexPath.row].time) \nweight: \(array[indexPath.row].weight) \nkey: \(array[indexPath.row].key) \nweightChange: \(array[indexPath.row].weightChange)")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           
            guard let uid = FIRAuth.auth()?.currentUser?.uid else{
                return
            }
            
            let key = array[indexPath.row].key
            
            let ref =  FIRDatabase.database().reference().child("users").child(uid).child("weightLog").child(key)
            
            ref.removeValue()
            
            //need to clear the array to avoid everything being populated in the table twice
            array.removeAll()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
            
        }
    }

    
    func addWeightButtonHandler(){
        var weight: String = ""
        let alert = UIAlertController(title: "Input", message: "Enter Weight", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.keyboardType = .decimalPad
        }
        
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            weight = (textField?.text)!
            self.addWeightInputToFirebase(weight: weight)
        }))
        
        self.present(alert, animated: true, completion: nil)

    }
    
    func addWeightInputToFirebase(weight: String) {
        //need to get old weight so we can find the change in weight
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        
        let lastWeight: Double
        
        if self.array.count > 0 {
            lastWeight = Double(self.array[0].weight)!
        } else {
            lastWeight = 0.0
        }
        
        let weightChange: Double
        
        if lastWeight == 0.0 {
            weightChange = 0.0
        }else {
            weightChange = Double(weight)! - lastWeight
        }
        
        
        let date = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM-dd-yyyy"
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "HH:mm a"
        
        let dateResult = dateFormat.string(from: date)
        let timeResult = timeFormat.string(from: date)
        
        
        let ref = FIRDatabase.database().reference().child("users").child(uid).child("weightLog").childByAutoId()
        
        
        //need to clear the array to avoid everything being populated in the table twice
        array.removeAll()
        
        //updates the db with the entered weight
        let values = ["date":dateResult, "time":timeResult, "weight": weight, "weightChange": String(weightChange)]
        ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                return
            }
            
        })
        
        
    }
    
    
    
}
