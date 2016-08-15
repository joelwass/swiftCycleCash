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

enum Categories:Int {
    case Automotive = 0
    case Groceries
    case Dining
    case Retail
    case Services
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
    let categories = ["Automotive", "Groceries", "Restaurants/Dining", "Retail", "Services"]
    
    var selectedIndexPath:NSIndexPath?
    var cellSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = UIColor.init(hex:0xcef4f5)
        self.view.backgroundColor = UIColor.init(hex:0xcef4f5)
        self.titleLabel.text = "Redeem Points"
        self.titleLabel.font = UIFont(name: fontOfChoice, size: 30.0)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = UIColor.init(hex:0xcef4f5)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        if (cellSelected) {
            self.cellSelected = false
             self.tableView.deselectRowAtIndexPath(self.selectedIndexPath!, animated: true)
        }
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
        return categories.count
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
        let categoryVC = self.storyboard?.instantiateViewControllerWithIdentifier("CategoryVC") as! CategoryVC

        switch indexPath.row {
        case Categories.Automotive.rawValue:
            categoryVC.logos = [UIImage.init(named: "carShopLogo")!]
            categoryVC.titleText = "Automotive"
            break
        case Categories.Groceries.rawValue:
            categoryVC.logos = []
            categoryVC.titleText = "Groceries"
            break
        case Categories.Dining.rawValue:
            categoryVC.logos = []
            categoryVC.titleText = "Dining"
            break
        case Categories.Retail.rawValue:
            categoryVC.logos = []
            categoryVC.titleText = "Retail"
            break
        case Categories.Services.rawValue:
            categoryVC.logos = []
            categoryVC.titleText = "Services"
            break
        default:
            break
        }
        
        self.selectedIndexPath = indexPath
        self.cellSelected = true
        
        self.navigationController?.pushViewController(categoryVC, animated: true)
    }

}
