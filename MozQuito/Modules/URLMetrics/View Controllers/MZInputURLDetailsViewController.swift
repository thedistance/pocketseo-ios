//
//  MZInputURLDetailsViewController.swift
//  MozQuito
//
//  Created by Josh Campion on 25/02/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit
import JCLocalization

class MZInputURLDetailsViewController: MZURLDetailsViewController {

    @IBOutlet weak var urlInputView:MZURLInputView!
    
    override var urlString:String? {
        didSet {
            urlInputView.inputStack.safariButton.hidden = urlString?.isEmpty ?? true
            urlInputView.inputStack.refreshButton.hidden = urlString?.isEmpty ?? true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // configure the input stack
        urlInputView.inputStack.urlTextFieldStack.textField.delegate = self
        urlInputView.inputStack.safariButton.addTarget(self, action: "safariTapped:", forControlEvents: .TouchUpInside)
        urlInputView.inputStack.safariButton.hidden = true
        
        urlInputView.inputStack.refreshButton.addTarget(self, action: "refreshTapped:", forControlEvents: .TouchUpInside)
        urlInputView.inputStack.refreshButton.hidden = true
        
        // configure the distance stack
        metricsVC.distanceView?.tdStack.delegate = self
    }

}

extension MZInputURLDetailsViewController: MZDistanceStackDelegate {

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
        
        contactSheet.modalInPopover = true
        contactSheet.modalPresentationStyle = .Popover
        
        self.presentViewController(contactSheet, fromSourceItem: .View(sender))
    }
    
    func distanceStackRequestsWebsite(stack: MZDistanceStack, sender: UIButton) {
        
        guard let url = NSURL(string: LocalizedString(.TheDistanceContactWebsiteURL)) else { return }
        
        let websiteEvent = AnalyticEvent(category: .Meta, action: .viewDistanceWebsite, label: nil)
        AppDependencies.sharedDependencies().analyticsInteractor?.sendAnalytic(websiteEvent)
        
        self.openURL(url, fromSourceItem: .View(sender))
    }
}

extension MZInputURLDetailsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        urlString = textField.text
        
        return true
    }
}