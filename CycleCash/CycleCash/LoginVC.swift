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
    
    var dimView:DimView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.logoImage.image = UIImage(named: "cycleCashLogo")
        self.view.backgroundColor = UIColor.init(hex: 0xcef4f5)
        
        self.loginSignUpButton.backgroundColor = UIColor.init(hex: 0xb4dda5)
        self.loginSignUpButton.layer.cornerRadius = 5
        self.loginSignUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.loginSignUpButton.setTitle("Log In", forState: .Normal)
        self.loginSignUpButton.titleLabel?.font = UIFont(name: fontOfChoice, size: 18.0)
    
        self.emailLabel.font = UIFont(name: fontOfChoice, size: 18.0)
        self.passwordLabel.font = UIFont(name: fontOfChoice, size: 18.0)
        
        self.viewSwitchButton.backgroundColor = UIColor.init(hex: 0xdacba0)
        self.viewSwitchButton.layer.cornerRadius = 4
        self.viewSwitchButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.viewSwitchButton.setTitle("Sign Up", forState: .Normal)
        self.viewSwitchButton.titleLabel?.font = UIFont(name: fontOfChoice, size: 18.0)
        
        emailTF.delegate = self
        passwordTF.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        self.emailTF.text = ""
        self.passwordTF.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginSignUp(sender: AnyObject) {
        
        dimView = DimView(frame: CGRectMake(0,0,self.view.frame.width,self.view.frame.height))
        self.view.addSubview(dimView!)
        self.view.bringSubviewToFront(dimView!)
        
        switch currentState {
        case .Login:
            API.sharedInstance().logIn(emailTF.text!, password: passwordTF.text!) { response in
                print(response)
                dispatch_async(dispatch_get_main_queue(), {
                    self.dimView?.removeFromSuperview()
                })
                if (response["success"] == true) {
                    self.loginSuccessful(response)
                } else if (response["success"] == false) {
                    self.loginFailure(response)
                }
            }
            break
        case .Signup:
            API.sharedInstance().signUp(emailTF.text!, password: passwordTF.text!) { response in
                print(response)
                dispatch_async(dispatch_get_main_queue(), {
                    self.dimView?.removeFromSuperview()
                })
                if (response["success"] == true) {
                    self.loginSuccessful(response)
                } else if (response["success"] == false) {
                    self.signupFailure(response)
                }
            }
            break
        }
    }
    
    func loginSuccessful(response: JSON) {
        if let userid = response["user"]["email"].string {
            GlobalSettings.SharedInstance.UserEmail = userid
        }
        if let pedalPoints = response["user"]["pedal_points"].int {
            GlobalSettings.SharedInstance.PedalPoints = pedalPoints
        }
        if let timeTraveled = response["user"]["time_traveled"].int {
            GlobalSettings.SharedInstance.TimeTraveled = timeTraveled
        }
        if let distanceTraveled = response["user"]["distance_traveled"].double {
            GlobalSettings.SharedInstance.DistanceTraveled = distanceTraveled
        }
        dispatch_async(dispatch_get_main_queue(), { [weak self] in
            let homeNavVC = self?.storyboard?.instantiateViewControllerWithIdentifier("navVC") as! navVC
            self?.presentViewController(homeNavVC, animated: true, completion: nil)
        })
    }
    
    func loginFailure(response: JSON) {
        dispatch_async(dispatch_get_main_queue(), { [weak self] in
            let alert = UIAlertController(title: "Uh Oh", message: response["message"].string, preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "Nice", style: .Default, handler: nil)
            alert.addAction(OKAction)
            self?.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    func signupFailure(response: JSON) {
        dispatch_async(dispatch_get_main_queue(), { [weak self] in
            let alert = UIAlertController(title: "Uh Oh", message: response["message"].string, preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "Nice", style: .Default, handler: nil)
            alert.addAction(OKAction)
            self?.presentViewController(alert, animated: true, completion: nil)
        })
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
