//
//  CategoryCell.swift
//  CycleCash
//
//  Created by Joel Wasserman on 8/7/16.
//  Copyright © 2016 cyclecash. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.init(hex:0xcef4f5)
        self.titleLabel.layer.backgroundColor = UIColor.whiteColor().CGColor
        self.titleLabel.textColor = UIColor.init(hex:0xcef4f5)
        self.titleLabel.layer.cornerRadius = 18
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
