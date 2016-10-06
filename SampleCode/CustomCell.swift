//
//  CustomCell.swift
//  SampleCode
//
//  Created by Hasya.Panchasra on 20/04/16.
//  Copyright © 2016 bv. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
   
    @IBOutlet var lblData: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
