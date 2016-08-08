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
    @IBOutlet weak var milesBottomlabel: UILabel!
    @IBOutlet weak var durationBottomLabel: UILabel!
    @IBOutlet weak var speedBottomLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var bottomHr: UIView!
    
    @IBOutlet weak var distanceBottomHr: UIView!
    @IBOutlet weak var speedDurationHr: UIView!
    @IBOutlet weak var buttonTopHr: UIView!
    
    var distance = 0.0
    var duration = NSTimer()
    var speed = 0.0

    let fontOfChoice = UserSettings.SharedInstance.Font
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.adView.image = UIImage(named: "carShopLogo")
        self.titleLabel.text = "Track Your Miles"
        self.view.backgroundColor = UIColor.init(hex:0xcef4f5)
        
        self.startButton.layer.cornerRadius = 10
        self.startButton.setTitle("Start", forState: .Normal)
        self.startButton.backgroundColor = UIColor.greenColor()
        self.startButton.layer.opacity = 0.5
        
        self.stopButton.layer.cornerRadius = 10
        self.stopButton.setTitle("Stop", forState: .Normal)
        self.stopButton.backgroundColor = UIColor.redColor()
        self.stopButton.layer.opacity = 0.5
        
        self.milesLabel.font = UIFont(name: fontOfChoice, size: 75.0)
        self.durationLabel.font = UIFont(name: fontOfChoice, size: 60.0)
        self.speedLabel.font = UIFont(name: fontOfChoice, size: 60.0)
        self.stopButton.titleLabel?.font = UIFont(name: fontOfChoice, size: 34.0)
        self.startButton.titleLabel?.font = UIFont(name: fontOfChoice, size: 34.0)
        self.milesBottomlabel.font = UIFont(name: fontOfChoice, size: 14.0)
        self.durationBottomLabel.font = UIFont(name: fontOfChoice, size: 14.0)
        self.speedBottomLabel.font = UIFont(name: fontOfChoice, size: 14.0)
        self.titleLabel.font = UIFont(name: fontOfChoice, size: 21.0)
        
        bottomHr.layer.shadowColor = UIColor.blackColor().CGColor
        bottomHr.layer.shadowOffset = CGSizeMake(0, 1)
        bottomHr.layer.shadowOpacity = 0.5
        bottomHr.layer.shadowRadius = 1.0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stopPressed(sender: AnyObject) {
        
    }

    @IBAction func startPressed(sender: AnyObject) {
        
    }
    
    @IBAction func menuButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
