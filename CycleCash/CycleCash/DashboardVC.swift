//
//  DashboardVC.swift
//  CycleCash
//
//  Created by Joel Wasserman on 8/3/16.
//  Copyright © 2016 cyclecash. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {

    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var adView: UIImageView!
    
    @IBOutlet weak var distanceBottomHr: UIView!
    @IBOutlet weak var speedDurationHr: UIView!
    @IBOutlet weak var buttonTopHr: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.adView.image = UIImage(named: "carShopLogo")
        
        self.startButton.layer.cornerRadius = 10
        self.startButton.titleLabel?.text = "Start"
        
        self.stopButton.layer.cornerRadius = 10
        self.stopButton.titleLabel?.text = "Stop"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.topItem?.title = "Track Your Miles"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stopPressed(sender: AnyObject) {
        
    }

    @IBAction func startPressed(sender: AnyObject) {
        
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
