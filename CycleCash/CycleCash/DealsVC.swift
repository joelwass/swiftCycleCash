//
//  DealsVC.swift
//  CycleCash
//
//  Created by Joel Wasserman on 8/9/16.
//  Copyright © 2016 cyclecash. All rights reserved.
//

import UIKit

class DealsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let fontOfChoice = GlobalSettings.SharedInstance.Font
    var deals = [""]
    var titleText = ""
    
    let alertTitle = "Redeem"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = UIColor.init(hex:0xcef4f5)
        self.view.backgroundColor = UIColor.init(hex:0xcef4f5)
        self.titleLabel.text = titleText
        self.titleLabel.font = UIFont(name: fontOfChoice, size: 30.0)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = UIColor.init(hex:0xcef4f5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deals.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Category"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath) as? CategoryCell
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier) as? CategoryCell
        }
        cell?.titleLabel.text = deals[indexPath.row]
        cell?.titleLabel.font = UIFont(name: fontOfChoice, size: 24.0)
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)  {
        var pedalPointsToSpend = 0
        var alertMessage = ""
        var shouldShowAlert = false
        
        switch indexPath.row {
        case 0:
            alertMessage = "You will spend 5 pedal points on this coupon"
            pedalPointsToSpend = 5
            shouldShowAlert = true
            break
        case 1:
            break
        default:
            break
        }
        
        let hasEnoughPoints = (pedalPointsToSpend > GlobalSettings.SharedInstance.PedalPoints)
        
        if (shouldShowAlert && hasEnoughPoints) {
            let alert = UIAlertController(title: self.alertTitle, message: alertMessage, preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "Spend", style: .Default) { _ in
                dispatch_async(dispatch_get_main_queue(), {
                    print("Spending \(pedalPointsToSpend)")
                    self.showConfirmationAlertView("\(pedalPointsToSpend)")
                })
            }
            let CancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
            alert.addAction(OKAction)
            alert.addAction(CancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
        } else if (shouldShowAlert) {
            let alert = UIAlertController(title: self.alertTitle, message: "It looks like you don't have enough Pedal Points to redeem this coupon. Keep cycling and try again later!", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(OKAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func showConfirmationAlertView(pointsSpent:String) {
        let alert = UIAlertController(title: "Transaction Confirmed", message: "\(pointsSpent) Points Spent", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "Ok", style: .Default) { _ in
            dispatch_async(dispatch_get_main_queue(), {
                self.navigationController?.popToRootViewControllerAnimated(true)
            })
        }
        alert.addAction(OKAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
