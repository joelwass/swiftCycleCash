//
//  LaunchVC.swift
//  CycleCash
//
//  Created by Joel Wasserman on 8/15/16.
//  Copyright © 2016 cyclecash. All rights reserved.
//

import UIKit

class LaunchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        _ = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(self.presentNavController), userInfo: nil, repeats: false)
    }
    
    func presentNavController() {
        let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginVC") as! LoginVC
        self.presentViewController(loginVC, animated: true, completion: nil)
    }
}
