//
//  TabBarController2.swift
//  WeightTracker
//
//  Created by Jesse Alltop on 2/23/17.
//  Copyright © 2017 alltopafiTech. All rights reserved.
//


import UIKit
import Firebase
import Charts

class ProgressGraphController: UIViewController {
    
    private var array = [WeightEntry]()
    
    let lineChartView: LineChartView = {
        let lc = LineChartView()
        lc.translatesAutoresizingMaskIntoConstraints = false
        lc.noDataText = "There is no data to display."
        return lc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.array.removeAll()
        self.title = "Progress"
        self.view.backgroundColor = UIColor(red: 58/255, green: 245/255, blue: 170/255, alpha: 1)
        setupChart()
        
    }
    
    
    func setupChart() {
    
        buildArrayFromDatabase()
//        buildChartFromArray()
        
        
        self.view.addSubview(lineChartView)
        //need x,y,width,height
        lineChartView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        lineChartView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        lineChartView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        lineChartView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.array.removeAll()
        self.tabBarController?.navigationItem.title = "Progress"
        self.tabBarController?.navigationItem.rightBarButtonItem = nil

    }
    
    func buildChartFromArray() {
        
        //set up axis arrays
        var dates: [String] = []
        var weights: [Double] = []
        
        for i in 0..<array.count {
            dates.append(array[i].date)
            weights.append(Double(array[i].weight)!)
        }
        
        // 1 - creating an array of data entries
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0..<dates.count {
            yVals1.append(ChartDataEntry(x: Double(i), y: weights[i]))
        }
        
        // 2 - create a data set with our array
        let set1: LineChartDataSet = LineChartDataSet(values: yVals1, label: "Weight")
        set1.axisDependency = .left // Line will correlate with left axis values
        set1.setColor(UIColor.blue.withAlphaComponent(0.5)) // our line's opacity is 50%
        set1.setCircleColor(.blue) // our circle will be dark red
        set1.lineWidth = 2.0
        set1.circleRadius = 6.0 // the radius of the node circle
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = .blue
        set1.highlightColor = UIColor.white
        set1.drawCircleHoleEnabled = true
        
        
        //3 - create an array to store our LineChartDataSets
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        
        //4 - pass our months in for our x-axis label value along with our dataSets
        let data: LineChartData = LineChartData(dataSets: dataSets)
        data.setValueTextColor(UIColor.blue)
        
        
        //5 - finally set our data
        self.lineChartView.data = data
        self.lineChartView.xAxis.drawLabelsEnabled = false
        self.lineChartView.chartDescription?.text = ""
        
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
                    
                    self.array.append(WeightEntry(name: name, date: date, time: time, weight: weight, key: key))
                    
                    self.buildChartFromArray()
                    
                    
                }
            })
            
        })
        
    }
    
}











