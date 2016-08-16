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
import JCLocalization

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}

public enum SpamScore:Equatable {
    
    case None
    case Good(Double)
    case Medium(Double)
    case Bad(Double)
    
    init(score:Double?) {
        
        if let d = score {
            
            switch d {
            case 0..<5:
                self = .Good(d)
            case 5..<7:
                self = .Medium(d)
            default:
                self = .Bad(d)
            }
            
        } else {
            self = .None
        }
    }
    
    var description:String {
        switch self {
        case .None:
            return "-"
        case  .Good(let d):
            return String(Int(d))
        case .Medium(let d):
            return String(Int(d))
        case .Bad(let d):
            return String(Int(d))
        }
    }
    
    var colour:UIColor {
        switch self {
        case .Good:
            return UIColor(hexString: "4CAF50")!
        case .Medium:
            return UIColor(hexString: "FF9800")!
        case .Bad:
            return UIColor(hexString: "F44336")!
        case .None:
            return UIColor.lightGrayColor()
        }
    }
    
}

public func ==(s1:SpamScore, s2:SpamScore) -> Bool {
    switch (s1,s2) {
    case (.None, .None):
        return true
    case (.Good(let g1), .Good(let g2)):
        return g1 == g2
    case (.Medium(let g1), .Medium(let g2)):
        return g1 == g2
    case (.Bad(let g1), .Bad(let g2)):
        return g1 == g2
    default:
        return false
    }
}

class LinksTableViewCell: ListTableViewCell {
    
    @IBOutlet override weak var titleLabel:UILabel? { didSet { } }
    @IBOutlet override weak var subtitleLabel:UILabel? { didSet { } }
    
//    @IBOutlet weak var PALabel: UILabel!
//    @IBOutlet weak var DALabel: UILabel!
//    @IBOutlet weak var SpamScoreLabel: UILabel!
    @IBOutlet weak var anchorTextLabel: UILabel!
    @IBOutlet weak var followedTextLabel: ThemeLabel!
    
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
                
                // concat everything onto one line
                let titleFont = MZThemeVendor.defaultFont(.Body1, sizeCategory: .Large)!
                let titleColour = MZThemeVendor.defaultColour(.SecondaryText)!
                
                let titleAttributes:[String:AnyObject] = [NSFontAttributeName: titleFont, NSForegroundColorAttributeName: titleColour]
                
                let infoFont = MZThemeVendor.defaultFont(.Body2, sizeCategory: .Large)!
                let infoColour = MZThemeVendor.defaultColour(.Text)!
                
                let infoAttributes:[String:AnyObject] = [NSFontAttributeName: infoFont, NSForegroundColorAttributeName: infoColour]
                
                let mutString = NSMutableAttributedString(string: "")
                
                
                if let pa = link.pageAuthority {
                    let roundedPA = pa.roundToPlaces(0)
                    
                    mutString.appendAttributedString(NSAttributedString(string: "PA ", attributes: titleAttributes))
                    mutString.appendAttributedString(NSAttributedString(string: String(Int(roundedPA)) + "  ", attributes: infoAttributes))
                }
                
                if let da = link.domainAuthority {
                    let roundedDA = da.roundToPlaces(0)
                    
                    mutString.appendAttributedString(NSAttributedString(string: "DA ", attributes: titleAttributes))
                    mutString.appendAttributedString(NSAttributedString(string: String(Int(roundedDA)) + "  ", attributes: infoAttributes))
                }
                
                //Once paid version becomes available make check here on type of app , if paid then enable the below
                //mutString.appendAttributedString(NSAttributedString(string: "Spam ", attributes: titleAttributes))
                //mutString.appendAttributedString(NSAttributedString(string: link.spamScore.description + "  ", attributes: [NSFontAttributeName: infoFont, NSForegroundColorAttributeName: link.spamScore.colour]))
                
                let linkText = link.followed ? LocalizedString(.LinksFilterFollow) : LocalizedString(.LinksFilterNoFollow)
                let linkColour = MZThemeVendor.defaultColour(link.followed ? .Accent : .SecondaryText)!
                
                mutString.appendAttributedString(NSAttributedString(string: linkText, attributes: [NSFontAttributeName: titleFont, NSForegroundColorAttributeName: linkColour]))
                
                followedTextLabel.attributedText = mutString
                
                //temporary check as free version will always return .None however the code below will not be correct for future paid version
                if link.spamScore == .None {
                    self.colourBar.hidden = true
                } else {
                    self.colourBar.hidden = false
                    self.colourBar.backgroundColor = link.spamScore.colour
                }
                
                if let anchorText = link.anchorText {
                    if anchorText.isEmpty {
                        self.anchorTextLabel!.text = "[NONE]"
                    } else {
                        self.anchorTextLabel!.text = link.anchorText
                    }
                }
                
                
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        for l in [titleLabel, subtitleLabel, PALabel, DALabel, SpamScoreLabel, anchorTextLabel] {
//            if l.preferredMaxLayoutWidth != l.frame.size.width {
//                l.preferredMaxLayoutWidth = l.frame.size.width
//                l.setNeedsLayout()
//            }
//        }
    }
}
