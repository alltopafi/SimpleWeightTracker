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
    
    let headerView: UIView = {
        let hv = UIView()
        hv.backgroundColor = .black
        hv.translatesAutoresizingMaskIntoConstraints = false
        return hv
    }()
    
    let leadTextView: UILabel = {
        let tv = UILabel()
        tv.textAlignment = .right
        tv.text = "Overall weight change is "
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let totalChangeTextField: UILabel = {
        let tv = UILabel()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textAlignment = .left
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let arrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        return iv
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.array.removeAll()
        self.title = "Progress"
//        self.view.backgroundColor = UIColor(red: 58/255, green: 245/255, blue: 170/255, alpha: 1)
        
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor(red: 82/255, green: 245/255, blue: 76/255, alpha: 1).cgColor, UIColor(red: 58/255, green: 245/255, blue: 170/255, alpha: 1).cgColor, UIColor.black.cgColor]
        
        self.view.layer.insertSublayer(gradient, at: 0)
        
        setupHeader()
        setupChart()
        
        
    }
    
    func setupHeader() {
        
        self.view.addSubview(headerView)
        //        //need x,y,width,height
        headerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
//        headerView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
//        headerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        headerView.addSubview(leadTextView)
//        //need x,y,width,height
        leadTextView.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
        leadTextView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        leadTextView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        leadTextView.heightAnchor.constraint(equalToConstant: 24).isActive = true

        headerView.addSubview(arrowImageView)
        //need x,y,width, height
        arrowImageView.leftAnchor.constraint(equalTo: leadTextView.rightAnchor, constant: 8).isActive = true
        arrowImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        arrowImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        arrowImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        headerView.addSubview(totalChangeTextField)
        //need x,y,width,height
        totalChangeTextField.leftAnchor.constraint(equalTo: arrowImageView.rightAnchor, constant: 8).isActive = true
        totalChangeTextField.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        totalChangeTextField.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
        totalChangeTextField.heightAnchor.constraint(equalToConstant: 24).isActive = true
        

    }
    
    
    func setupChart() {
    
        buildArrayFromDatabase()
//        buildChartFromArray()
        
        
        self.view.addSubview(lineChartView)
        //need x,y,width,height
        lineChartView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        lineChartView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10).isActive = true
        lineChartView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        lineChartView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
    }
    
    func findWeightChange() -> String {
        
        var weightChangeTotal: Double = 0.0
        
        for i in 0..<array.count {
            weightChangeTotal += Double(array[i].weightChange)!
        }
        
        return String(weightChangeTotal)
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
        set1.circleHoleColor = .blue
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
        
        let totalWeightChange: String = findWeightChange()
        
        totalChangeTextField.text = totalWeightChange + " lbs"
        
        if Double(totalWeightChange)! != 0.0 {
            if Double(totalWeightChange)! > 0.0 {
                arrowImageView.image = #imageLiteral(resourceName: "greenArrow")
            }else {
                arrowImageView.image = #imageLiteral(resourceName: "redArrow")
            }
        }
        
        
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
                    
                    self.array.append(WeightEntry(name: name, date: date, time: time, weight: weight, key: key, weightChange: weightChange))
                    
                    self.buildChartFromArray()
                    
                    
                }
            })
            
        })
        
    }
    
}











