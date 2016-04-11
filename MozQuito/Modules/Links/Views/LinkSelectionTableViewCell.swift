//
//  LinkSelectionTableViewCell.swift
//  MozQuito
//
//  Created by Josh Campion on 08/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit

class LinkSelectionTableViewCell: UITableViewCell, SelectionCell {

    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var detailLabel: UILabel?

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        self.accessoryType = selected ? .Checkmark : .None
    }

}
