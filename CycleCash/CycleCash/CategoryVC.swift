//
//  CategoryVC.swift
//  CycleCash
//
//  Created by Joel Wasserman on 8/9/16.
//  Copyright © 2016 cyclecash. All rights reserved.
//

import UIKit

class CategoryVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let fontOfChoice = GlobalSettings.SharedInstance.Font
    var logos = []
    var titleText = ""
    
    var selectedIndexPath:NSIndexPath?
    var cellSelected = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.text = titleText
        self.tableView.backgroundColor = UIColor.init(hex:0xcef4f5)
        self.view.backgroundColor = UIColor.init(hex:0xcef4f5)
        self.titleLabel.font = UIFont(name: fontOfChoice, size: 30.0)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = UIColor.init(hex:0xcef4f5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        if (cellSelected) {
            self.cellSelected = false
            self.tableView.deselectRowAtIndexPath(self.selectedIndexPath!, animated: true)
        }
    }
    
    @IBAction func backPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Logo"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath) as? LogoCell
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier) as? LogoCell
        }
        cell?.logoImage?.image = logos[indexPath.row] as? UIImage
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)  {
        let dealsVC = self.storyboard?.instantiateViewControllerWithIdentifier("DealsVC") as! DealsVC
        
        switch indexPath.row {
        case 0:
            dealsVC.deals = ["10% Off Overall Car Service"]
            dealsVC.titleText = "Car Shop"
            self.navigationController?.pushViewController(dealsVC, animated: true)
            break
        default:
            break
        }
        
        self.selectedIndexPath = indexPath
        self.cellSelected = true
    }
}
