//
//  MZURLDetailsViewController.swift
//  MozQuito
//
//  Created by Josh Campion on 02/02/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit
import StackView
//import PocketSEOViews
import ThemeKitCore
import JCPageViewController
import TheDistanceCore

class MZURLDetailsViewController: JCPageViewController {

    @IBOutlet weak var headerBackgroundView:ThemeView!
    @IBOutlet weak var urlInputView:MZURLInputView!
    private(set) var urlStack:StackView!
    
    var urlString:String? {
        didSet {
            metricsVC?.urlString = urlString
            
            urlInputView.inputStack.safariButton.hidden = urlString?.isEmpty ?? true
            urlInputView.inputStack.refreshButton.hidden = urlString?.isEmpty ?? true
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
        
        (pageControl?.collectionViewLayout as? JCPageControlCollectionViewFlowLayout)?.cellAlignment = .Left
        
        // configure this view
        urlInputView.inputStack.urlTextFieldStack.textField.delegate = self
        urlInputView.inputStack.safariButton.addTarget(self, action: "safariTapped:", forControlEvents: .TouchUpInside)
        urlInputView.inputStack.safariButton.hidden = true
        
        urlInputView.inputStack.refreshButton.addTarget(self, action: "refreshTapped:", forControlEvents: .TouchUpInside)
        urlInputView.inputStack.refreshButton.hidden = true
        
        headerBackgroundView?.layer.shadowOpacity = 0.27
        headerBackgroundView?.layer.shadowRadius = 4.0
        headerBackgroundView?.layer.shadowOffset = CGSizeMake(0, 4.0)
        headerBackgroundView?.layer.shadowColor = UIColor.blackColor().CGColor
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func safariTapped(sender:UIButton) {
        
        guard var str = urlString where !str.isEmpty else { return }
        
        if !(str.hasPrefix("http://") || str.hasPrefix("https://")) {
            str = "http://" + str
        }
        
        if let url = NSURL(string: str) {
            self.openURL(url, fromSourceItem: .View(sender))
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
    
    /// Standard action to return home
    @IBAction func unwindToHome(segue:UIStoryboardSegue) { }
    
}

extension MZURLDetailsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        urlString = textField.text
        
        return true
    }
}
