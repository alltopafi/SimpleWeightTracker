//
//  ViewController.swift
//  WeightTracker
//
//  Created by Jesse Alltop on 2/7/17.
//  Copyright © 2017 alltopafiTech. All rights reserved.
//

import UIKit
import Firebase

class LoginRegisterViewController: UIViewController {

    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 32/255, green: 216/255, blue: 132/255, alpha: 1)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    let loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.tintColor = .white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleRegisterChange), for: .valueChanged)
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    func handleRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        //change the layout of the view
    
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        nameTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor?.isActive = false
        
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextField.placeholder = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? "" : "Name"
        nameTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
    }
    
    func handleLoginRegister(){
       if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin(){
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, err) in
            if err != nil {
                print(err!)
                
                let alert = UIAlertController(title: "Alert", message: "There was an error logging in. \n Please check your email and password.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func handleRegister(){
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            return
        }

        FIRAuth.auth()?.createUser(withEmail: email,password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            guard let uid = user?.uid else{
                return
            }
            
            //created a new user
            let ref = FIRDatabase.database().reference().child("users").child(uid)
            let values = ["email": email,"name": name]
            ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if err != nil {
                    print(err!)
                    return
                }
                
                self.dismiss(animated: true, completion: nil)
                
            })
            
        })
        
    }
    
    let nameTextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 200/225, green: 200/225, blue: 200/225, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email address"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 200/225, green: 200/225, blue: 200/225, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 167/255, green: 242/255, blue: 214/255, alpha: 1)
        
       
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(loginRegisterSegmentedControl)
        
        setupInputsContainer()
        setupLoginRegisterButton()
        setupLoginRegisterSegmentedControl()
        
    }
    
    func setupLoginRegisterSegmentedControl() {
        //add ios9 constraints x,y,width, height
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    
    func setupInputsContainer(){
        //add ios9 constraints x,y,width, height
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeperatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeperatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        //add ios9 constraints x,y,width, height
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        //add ios9 constraints x,y,width, height
        nameSeperatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeperatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeperatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //add ios9 constraints x,y,width, height
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameSeperatorView.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        //add ios9 constraints x,y,width, height
        emailSeperatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeperatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeperatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //add ios9 constraints x,y,width, height
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSeperatorView.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
    }
    
    func setupLoginRegisterButton(){
        //add ios9 constraints x,y,width, height
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

