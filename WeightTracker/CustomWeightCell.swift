//
//  CustomWeightCell.swift
//  WeightTracker
//
//  Created by Jesse Alltop on 2/25/17.
//  Copyright © 2017 alltopafiTech. All rights reserved.
//

import UIKit

class CustomWeightCell: UITableViewCell {
    
    let weightView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isEditable = false
        return tv
    }()
    
    let lineView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .lightGray
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isEditable = false
        return tv
    }()
    
    let topLineView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .lightGray
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isEditable = false
        return tv
    }()
    
    let arrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        return iv
    }()
    
    let weightChangeTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 14, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 35, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(weightView)
        //need x,y,width,height constraints
        weightView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        weightView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        weightView.widthAnchor.constraint(equalToConstant: 85).isActive = true
        weightView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(lineView)
        //need x,y,widht,height constraints
        lineView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 14).isActive = true
        lineView.topAnchor.constraint(equalTo: (textLabel?.bottomAnchor)!).isActive = true
        lineView.widthAnchor.constraint(equalTo: (textLabel?.widthAnchor)!).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        addSubview(topLineView)
        //need x,y,widht,height constraints
        topLineView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        topLineView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        topLineView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        topLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        addSubview(weightChangeTextView)
        //need x,y,widht,height constraints
        weightChangeTextView.rightAnchor.constraint(equalTo: weightView.leftAnchor, constant: -12).isActive = true
        weightChangeTextView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        weightChangeTextView.widthAnchor.constraint(equalToConstant: 65).isActive = true
        weightChangeTextView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(arrowImageView)
        //need x,y,widht,height constraints
        arrowImageView.rightAnchor.constraint(equalTo: weightChangeTextView.leftAnchor, constant: -12).isActive = true
        arrowImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        arrowImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        arrowImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
