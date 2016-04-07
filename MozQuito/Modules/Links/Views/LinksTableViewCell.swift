//
//  LinksTableViewCell.swift
//  MozQuito
//
//  Created by Ashhad Syed on 06/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit

import Components
import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}



class LinksTableViewCell: ListTableViewCell {

    @IBOutlet override weak var titleLabel:UILabel? { didSet { } }
    @IBOutlet override weak var subtitleLabel:UILabel? { didSet { } }

    @IBOutlet weak var PALabel: UILabel!
    @IBOutlet weak var DALabel: UILabel!
    @IBOutlet weak var SpamScoreLabel: UILabel!
    @IBOutlet weak var anchorTextLabel: UILabel!
    
    @IBOutlet weak var colourBar: UIView!
    
    override var listItem: Listable? {
        didSet {
//            let info = listItem?.getListProperties()
            if let link = listItem as? MZMozscapeLinks {
                
                if let title = link.title {
                    if title.isEmpty {
                        self.titleLabel!.text = "[NO TITLE]"
                    } else {
                        self.titleLabel!.text = link.title
                    }
                }
                
                self.subtitleLabel!.text = link.canonicalURL?.absoluteString
                
                if let pa = link.pageAuthority {
                    let roundedPA = pa.roundToPlaces(0)
                    self.PALabel.text = String(Int(roundedPA))
                }
                
                if let da = link.domainAuthority {
                    let roundedDA = da.roundToPlaces(0)
                    self.DALabel.text = String(Int(roundedDA))
                }
                
                if let spamScore = link.spamScore {
                    self.SpamScoreLabel.text = String(Int(spamScore))
                }
                
                self.anchorTextLabel.text = link.anchorText
            }
        }
    }

}
