//
//  RedeemPointsVC.swift
//  CycleCash
//
//  Created by Joel Wasserman on 8/3/16.
//  Copyright © 2016 cyclecash. All rights reserved.
//

import UIKit

enum State {
    case categories
    case logos
    case carshop
}

class RedeemPointsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    
    let fontOfChoice = GlobalSettings.SharedInstance.Font
    let currentState = State.categories
    
    var autoCases = ["Car Shop"]
    var groceryCases = [""]
    var restarauntCases = [""]
    var retailCases = [""]
    var servicesCases = [""]
    
    var logos = [""]
    var deals = [""]
    let categories = ["Automotive", "Groceries", "Restaurants/Dining", "Retail", "Services"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = UIColor.init(hex:0xcef4f5)
        self.view.backgroundColor = UIColor.init(hex:0xcef4f5)
        self.titleLabel.text = "Redeem Points"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = UIColor.init(hex:0xcef4f5)
        self.titleLabel.font = UIFont(name: fontOfChoice, size: 30.0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentState {
        case State.categories:
            return categories.count
        case State.logos:
            return logos.count
        case State.carshop:
            return deals.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Category"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath) as? CategoryCell
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier) as? CategoryCell
        }
        cell?.titleLabel.text = categories[indexPath.row]
        cell?.titleLabel.font = UIFont(name: fontOfChoice, size: 24.0)
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)  {

    }

}
