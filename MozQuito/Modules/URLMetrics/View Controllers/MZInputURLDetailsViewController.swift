//
//  MZInputURLDetailsViewController.swift
//  MozQuito
//
//  Created by Josh Campion on 25/02/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit

import JCPageViewController
import JCLocalization
import Components

class MZInputURLDetailsViewController: MZURLDetailsViewController {

    @IBOutlet weak var urlInputView:MZURLInputView!
    
    override var urlString:String? {
        didSet {
            
            if urlInputView.inputStack.urlSearchBar.text != urlString {
                // this will typically be from opening the app via the
               urlInputView.inputStack.urlSearchBar.text = urlString
            }
            
            urlInputView.inputStack.safariButton.hidden = urlString?.isEmpty ?? true
            urlInputView.inputStack.refreshButton.hidden = urlString?.isEmpty ?? true
            configureFilterVisibility()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // configure the input stack
        urlInputView.inputStack.urlSearchBar.delegate = self
        urlInputView.inputStack.safariButton.addTarget(self, action: #selector(MZURLDetailsViewController.safariTapped(_:)), forControlEvents: .TouchUpInside)
        urlInputView.inputStack.safariButton.hidden = true
        
        urlInputView.inputStack.refreshButton.addTarget(self, action: #selector(MZURLDetailsViewController.refreshTapped(_:)), forControlEvents: .TouchUpInside)
        urlInputView.inputStack.refreshButton.hidden = true
        
        urlInputView.inputStack.filterButton.addTarget(linksVC, action: #selector(MZLinksViewController.filterTapped(_:)), forControlEvents: .TouchUpInside)
        urlInputView.inputStack.filterButton.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //self.urlString = "thedistance.co.uk"
        // configure the distance stack
        (metricsVC.distanceView?.distanceStack as? MZDistanceApplicationStack)?.delegate = self
    }
    
    override func configureFilterVisibility() {
        let invalidURL = urlString?.isEmpty ?? true
        let validLinksPage = self.currentViewController is MZLinksViewController
        let validLinks =  validLinksPage && !invalidURL
        
        let newValue = !validLinks
        if urlInputView.inputStack.filterButton.hidden != newValue {
            self.urlInputView.inputStack.filterButton.hidden = newValue
        }
        
        if self.urlInputView.inputStack.refreshButton.hidden == newValue {
            self.urlInputView.inputStack.refreshButton.hidden = !newValue
        }
        
        self.urlInputView.layoutIfNeeded()
    }
}

extension MZInputURLDetailsViewController: MZDistanceApplicationStackDelegate {

    func distanceStackRequestsSendFeedback(stack: MZDistanceStack, sender: UIButton) {
        sendEmail([LocalizedString(.TheDistancePanelSendFeedbackEmailAddress)],
            withSubject:LocalizedString(.TheDistancePanelSendFeedbackSubject),
        fromSender: sender)

    }
    
    func distanceStackRequestsGetInTouch(stack: MZDistanceStack, sender: UIButton) {
        let contactSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        contactSheet.addAction(UIAlertAction(title: LocalizedString(.TheDistancePanelGetInTouchOptionEmail),
            style: .Default,
            handler: { (_) -> Void in
                self.sendEmail([LocalizedString(.TheDistanceContactEmail)],
                    withSubject:"",
                    fromSender: sender
                )
        }))
        
        contactSheet.addAction(UIAlertAction(title: LocalizedString(.TheDistancePanelGetInTouchOptionPhone),
            style: .Default,
            handler: { (_) -> Void in
                
                guard let urlPhoneNumber = LocalizedString(.TheDistanceContactPhone).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet()),
                    let phoneURL = NSURL(string: "telprompt://" + urlPhoneNumber)
                    where UIApplication.sharedApplication().canOpenURL(phoneURL) else { return }
                
                UIApplication.sharedApplication().openURL(phoneURL)
        }))
        
        contactSheet.addAction(UIAlertAction(title: LocalizedString(.TheDistancePanelGetInTouchOptionCancel),
            style: .Cancel,
            handler: nil))
        
        contactSheet.modalPresentationStyle = .Popover
        
        self.presentViewController(contactSheet, fromSourceItem: .View(sender))
    }
    
    func distanceStackRequestsWebsite(stack: MZDistanceStack, sender: UIButton) {
        
        guard let url = NSURL(string: LocalizedString(.TheDistanceContactWebsiteURL)) else { return }
        
        let websiteEvent = AnalyticEvent(category: .Meta, action: .viewDistanceWebsite, label: nil)
        AppDependencies.sharedDependencies().analyticsReporter?.sendAnalytic(websiteEvent)
        
        self.openURL(url, fromSourceItem: .View(sender))
    }
}

extension MZInputURLDetailsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        urlString = searchBar.text
        searchBar.resignFirstResponder()
    }
}