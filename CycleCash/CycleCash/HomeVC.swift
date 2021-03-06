//
//  HomeVC.swift
//  CycleCash
//
//  Created by Joel Wasserman on 8/3/16.
//  Copyright © 2016 cyclecash. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var homePageImage: UIImageView!
    @IBOutlet weak var cycleCashLabel: UILabel!
    @IBOutlet weak var trackYourMilesButton: UIButton!
    @IBOutlet weak var pedalPointsButton: UIButton!
    @IBOutlet weak var spendPointsButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    let fontOfChoice = GlobalSettings.SharedInstance.Font
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.homePageImage.image = UIImage(named: "cycleCashLogo")
        self.view.backgroundColor = UIColor.init(hex:0xcef4f5)
        self.cycleCashLabel.textColor = UIColor.whiteColor()
        self.trackYourMilesButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.pedalPointsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.spendPointsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.logoutButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        self.trackYourMilesButton.setTitle("Track Your Miles", forState: .Normal)
        self.pedalPointsButton.setTitle("Pedal Points", forState: .Normal)
        self.spendPointsButton.setTitle("Spend Points", forState: .Normal)
        self.logoutButton.setTitle("Logout", forState: .Normal)
        
        self.cycleCashLabel.font = UIFont(name: fontOfChoice, size: 42.0)
        self.trackYourMilesButton.titleLabel?.font = UIFont(name: fontOfChoice, size: 20.0)
        self.pedalPointsButton.titleLabel?.font = UIFont(name: fontOfChoice, size: 20.0)
        self.spendPointsButton.titleLabel?.font = UIFont(name: fontOfChoice, size: 20.0)
        self.logoutButton.titleLabel?.font = UIFont(name: fontOfChoice, size: 18.0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if (GlobalSettings.SharedInstance.Onboarded == false) {
            self.presentOnboardingView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func trackYourMilesPressed(sender: AnyObject) {
        let dashboardVC = self.storyboard?.instantiateViewControllerWithIdentifier("DashboardVC") as! DashboardVC
        self.navigationController?.pushViewController(dashboardVC, animated: true)
    }

    @IBAction func pedalPointsPressed(sender: AnyObject) {
        let pedalPointsVC = self.storyboard?.instantiateViewControllerWithIdentifier("PedalPointsVC") as! PedalPointsVC
        self.navigationController?.pushViewController(pedalPointsVC, animated: true)
    }
    
    @IBAction func spendPointsPressed(sender: AnyObject) {
        let redeemPointsVC = self.storyboard?.instantiateViewControllerWithIdentifier("RedeemPointsVC") as! RedeemPointsVC
        self.navigationController?.pushViewController(redeemPointsVC, animated: true)
    }
    
    @IBAction func logoutPressed(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        GlobalSettings.SharedInstance.UserEmail = "None"
    }
    
    func presentOnboardingView() {
        dispatch_async(dispatch_get_main_queue(), { [weak self] () -> () in
            GlobalSettings.SharedInstance.Onboarded = true
            let alert = UIAlertController(title: "Welcome!", message: "Pedal Points is all about rewarding bikers for biking. Once you start tracking your bike rides, for each mile you ride you'll get one pedal point, which you can use to redeem great deals from local vendors in the area! Enjoy!", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(OKAction)
            self?.presentViewController(alert, animated: true, completion: nil)
        })
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
}
