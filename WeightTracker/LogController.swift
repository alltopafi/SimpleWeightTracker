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
    
    let cellId = "cellId"
    private var array = [WeightEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Log"
        self.view.backgroundColor = .white
        
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
                    
                    print(child)
                    
                    
                    
                    let values = (child as! FIRDataSnapshot).value as? NSDictionary

                    let date = values?["date"] as! String
                    let time = values?["time"] as! String
                    let weight = values?["weight"] as! String

                    self.array.append(WeightEntry(name: name, date: date, time: time, weight: weight))
                    
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
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
        cell.textLabel?.text = array[indexPath.row].weight
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("name: \(array[indexPath.row].name) \ndate: \(array[indexPath.row].date) \ntime: \(array[indexPath.row].time) \nweight: \(array[indexPath.row].weight)")
    }

    
    func addWeightButtonHandler(){
        var weight: String = ""
        let alert = UIAlertController(title: "Input", message: "Enter Weight", preferredStyle: .alert)
        alert.addTextField { (textField) in
            
        }
        
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            weight = (textField?.text)!
            self.addWeightInputToFirebase(weight: weight)
        }))
        
        self.present(alert, animated: true, completion: nil)

    }
    
    func addWeightInputToFirebase(weight: String) {
        
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        
        let date = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM-dd-yyyy"
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "HH:mm a"
        
        let dateResult = dateFormat.string(from: date)
        let timeResult = timeFormat.string(from: date)
        
        
        let ref = FIRDatabase.database().reference().child("users").child(uid).child("weightLog").childByAutoId()
        
        
        let refName = FIRDatabase.database().reference().child("users").child(uid)
        
        
        
        refName.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as? String
            
            self.array.append(WeightEntry(name: name!, date: dateResult, time: timeResult, weight: weight))
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

            
        }) { (error) in
            print(error)
            return
        }
        
        
        //updates the db with the entered weight
        let values = ["date":dateResult, "time":timeResult, "weight": weight]
        ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                return
            }
            
        })

//        array.append(WeightEntry(name: name, date: dateResult, time: timeResult, weight: weight))
        
        
        
    }
    
    
    
}
