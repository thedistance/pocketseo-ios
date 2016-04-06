//
//  LinksTableViewCell.swift
//  MozQuito
//
//  Created by Ashhad Syed on 06/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit

import Components

class LinksTableViewCell: ListTableViewCell {

    @IBOutlet override weak var titleLabel:UILabel? { didSet { } }
    @IBOutlet override weak var subtitleLabel:UILabel? { didSet { } }

    @IBOutlet weak var PALabel: UILabel!
    @IBOutlet weak var DALabel: UILabel!
    @IBOutlet weak var SpamScoreLabel: UILabel!
    @IBOutlet weak var anchorTextLabel: UILabel!
    
    override var listItem: Listable? {
        didSet {
//            let info = listItem?.getListProperties()
            if let link = listItem as? MZMozscapeLinks {
                self.titleLabel!.text = link.title
                self.subtitleLabel!.text = link.canonicalURL?.absoluteString
                self.PALabel.text = String(link.pageAuthority)
                self.DALabel.text = String(link.domainAuthority)
                self.SpamScoreLabel.text = String(link.spamScore)
                self.anchorTextLabel.text = link.anchorText
            }
        }
    }

}
