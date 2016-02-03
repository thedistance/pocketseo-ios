//
//  MZURLDetailsViewController.swift
//  MozQuito
//
//  Created by Josh Campion on 02/02/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit
import StackView
import PocketSEOViews
import ThemeKit
import JCPageViewController
import TheDistanceCore

class MZURLDetailsViewController: JCPageViewController {

    @IBOutlet weak var urlInputView:MZURLInputView!
    private(set) var urlStack:StackView!
    
    var urlString:String? {
        didSet {
            metricsVC?.urlString = urlString
        }
    }
    
    var metricsVC:MZURLMetricsViewController!
    var linksVC:UIViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // create the selection before `viewDidLoad()` queries it
        let selection = ThemeView(frame: CGRectMake(0,0,0,4))
        selection.backgroundColourStyle = .Accent
        self.selectionIndicator = selection
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure the JCPageViewController settings
        viewControllers = [metricsVC, linksVC]
        
        (self.pageControl?.collectionViewLayout as? JCPageControlCollectionViewFlowLayout)?.cellAlignment = .Left
        
        // configure this view
        urlInputView.inputStack.urlTextFieldStack.textField.delegate = self
        urlInputView.inputStack.safariButton.addTarget(self, action: "safariTapped:", forControlEvents: .TouchUpInside)
        urlInputView.inputStack.refreshButton.addTarget(self, action: "refreshTapped:", forControlEvents: .TouchUpInside)
    }
    
    func safariTapped(sender:UIButton) {
        
        guard let str = urlString where !str.isEmpty else { return }
        
        if let url = NSURL(string: str) {
            self.openInSafari(url)
        }
    }
    
    func refreshTapped(sender:UIButton) {
        
        // reset the property to reload the views where appropriate
        let str = urlString
        urlString = str
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        
        if let pageControlCell = cell as? JCPageControlCell {
            pageControlCell.backgroundColor = UIColor.clearColor()
            pageControlCell.contentView.backgroundColor = UIColor.clearColor()
            pageControlCell.titleLabel.textColor = MZThemeVendor.defaultColour(.LightText)
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegatePageControlLayout
    
    override func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, titleFontForIndexPath indexPath: NSIndexPath) -> UIFont? {
        return MZThemeVendor.defaultFont(.SubHeadline, sizeCategory: nil)
    }
    
}

extension MZURLDetailsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        urlString = textField.text
        
        return true
    }
    
}
