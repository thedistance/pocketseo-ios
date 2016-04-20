//
//  MZLinksSelectionViewController.swift
//  MozQuito
//
//  Created by Josh Campion on 08/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import SelectionViewController

class MZLinksSelectionViewController: TDSelectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectionType = .SingleSectioned
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    @IBAction func cancelTapped(sender:UIBarButtonItem) {
        delegate?.selectionViewControllerRequestsCancel(self)
    }
    
    @IBAction func doneTapped(sender:UIBarButtonItem) {
        delegate?.selectionViewControllerRequestsDismissal(self)
    }
}