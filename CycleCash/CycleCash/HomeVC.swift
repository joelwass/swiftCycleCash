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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.homePageImage.image = UIImage(named: "cycleCashLogo")
        self.view.backgroundColor = UIColor.cyanColor()
        self.trackYourMilesButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.pedalPointsButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.spendPointsButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBarHidden = true
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
