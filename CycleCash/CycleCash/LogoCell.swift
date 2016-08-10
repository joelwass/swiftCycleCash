//
//  LogoCell.swift
//  CycleCash
//
//  Created by Joel Wasserman on 8/7/16.
//  Copyright © 2016 cyclecash. All rights reserved.
//

import UIKit

class LogoCell: UITableViewCell {

    @IBOutlet weak var logoImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.init(hex:0xcef4f5)
        self.logoImage.layer.cornerRadius = 18 // TODO fix this
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
