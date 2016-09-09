//
//  LoginVC.swift
//  CycleCash
//
//  Created by Joel Wasserman on 9/5/16.
//  Copyright © 2016 cyclecash. All rights reserved.
//

import UIKit

enum LoginState: Int {
    case Login = 0
    case Signup
}

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginSignUpButton: UIButton!
    @IBOutlet weak var viewSwitchButton: UIButton!
    
    let fontOfChoice = GlobalSettings.SharedInstance.Font
    var currentState = LoginState.Login
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.logoImage.image = UIImage(named: "cycleCashLogo")
        self.view.backgroundColor = UIColor.init(hex:0xcef4f5)
        
        self.loginSignUpButton.backgroundColor = UIColor.blueColor()
        self.loginSignUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.loginSignUpButton.setTitle("Log In", forState: .Normal)
        self.loginSignUpButton.titleLabel?.font = UIFont(name: fontOfChoice, size: 18.0)
    
        self.emailLabel.font = UIFont(name: fontOfChoice, size: 18.0)
        self.passwordLabel.font = UIFont(name: fontOfChoice, size: 18.0)
        
        self.viewSwitchButton.backgroundColor = UIColor.orangeColor()
        self.viewSwitchButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.viewSwitchButton.setTitle("Sign Up", forState: .Normal)
        self.viewSwitchButton.titleLabel?.font = UIFont(name: fontOfChoice, size: 18.0)
        
        emailTF.delegate = self
        passwordTF.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginSignUp(sender: AnyObject) {
        
        switch currentState {
        case .Login:
            API.sharedInstance().logIn(emailTF.text!, password: passwordTF.text!) { response in
                print(response)
            }
            break
        case .Signup:
            API.sharedInstance().signUp(emailTF.text!, password: passwordTF.text!) { response in
                print(response)
            }
            break
        }
    }

    @IBAction func switchViews(sender: AnyObject) {
        
        switch currentState {
        case .Login:
            self.currentState = .Signup
            self.loginSignUpButton.setTitle("Sign Up", forState: .Normal)
            self.viewSwitchButton.setTitle("Log In", forState: .Normal)
            break
        case .Signup:
            self.currentState = .Login
            self.loginSignUpButton.setTitle("Log In", forState: .Normal)
            self.viewSwitchButton.setTitle("Sign Up", forState: .Normal)
            break
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
