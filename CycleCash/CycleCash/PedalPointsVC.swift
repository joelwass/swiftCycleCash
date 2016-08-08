//
//  PedalPointsVC.swift
//  CycleCash
//
//  Created by Joel Wasserman on 8/3/16.
//  Copyright © 2016 cyclecash. All rights reserved.
//

import UIKit

class PedalPointsVC: UIViewController {

    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var adView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var bottomHr: UIView!
    
    let fontOfChoice = GlobalSettings.SharedInstance.Font
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.adView.image = UIImage(named: "carShopLogo")
        self.titleLabel.text = "My Pedal Points"
        self.view.backgroundColor = UIColor.init(hex:0xcef4f5)
        
        self.pointsLabel.font = UIFont(name: fontOfChoice, size: 150.0)
        self.titleLabel.font = UIFont(name: fontOfChoice, size: 21.0)
        
        bottomHr.layer.shadowColor = UIColor.blackColor().CGColor
        bottomHr.layer.shadowOffset = CGSizeMake(0, 1)
        bottomHr.layer.shadowOpacity = 0.5
        bottomHr.layer.shadowRadius = 1.0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.pointsLabel.text = "\(GlobalSettings.SharedInstance.PedalPoints)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuButtonClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
