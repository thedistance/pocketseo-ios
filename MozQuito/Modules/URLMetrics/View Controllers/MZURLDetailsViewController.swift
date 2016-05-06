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

import Components

import MessageUI
import JCLocalization
import DeviceKit

import ReactiveCocoa

class MZURLDetailsViewController: JCPageViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var headerBackgroundView:ThemeView!

    var urlString:String? {
        didSet {
            metricsVC?.urlString.value = urlString
            linksVC?.urlString.value = urlString
        }
    }
    
    var metricsVC:MZURLMetricsViewController!
    var linksVC:MZLinksViewController!
    
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
        viewControllers = [metricsVC,linksVC]
        
        (pageControl?.collectionViewLayout as? JCPageControlCollectionViewFlowLayout)?.cellAlignment = .Left
        pageContainer?.bounces = false
        self.delegate = self
        
        // configure this view
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
            
            let openEvent = AnalyticEvent(category: .DataRequest, action: .openInBrowser, label: url.absoluteString)
            AppDependencies.sharedDependencies().analyticsReporter?.sendAnalytic(openEvent)
            
            self.openURL(url, fromSourceItem: .View(sender))
        }
    }
    
    func refreshTapped(sender:UIButton) {
        
        let str = urlString
        
        // force a refresh of the string
        urlString = ""
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
    
    
    func sendEmail(recipients:[String], withSubject subject:String, fromSender:UIView) {
        
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        
        mailVC.setToRecipients(recipients)
        mailVC.setSubject(subject)
        
        
        let platformInfo = "\(Device().description) \(UIDevice.currentDevice().systemName) \(UIDevice.currentDevice().systemVersion)"
        
        let appName = (NSBundle.mainBundle().infoDictionary?["CFBundleName"] as? String) ?? "PocketSEO"
        let appVersion = (NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String) ?? "-"
        let emailBody = "\n\n" + String(format: LocalizedString(.TheDistancePanelEmailBody), appName, platformInfo, appVersion)
        
        mailVC.setMessageBody(emailBody, isHTML: false)
        
        self.presentViewController(mailVC, fromSourceItem: .View(fromSender))
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func configureFilterVisibility() {
        
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIDevice.currentDevice().getDeviceSupportedInterfaceOrientations()
    }
}

extension MZURLDetailsViewController: JCPageViewControllerDelegate {
    
    func pageViewController(pageViewController: JCPageViewController, didChangeCurrentPageTo page: UIViewController, atIndex: Int) {
        configureFilterVisibility()
    }
}