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

class MZURLDetailsViewController: JCPageViewController {

    let safariButton = ThemeButton()
    let urlTextField = ThemeTextField()
    let refreshButton = ThemeButton()
    
    private(set) var urlStack:StackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let selection = ThemeView(frame: CGRectMake(0,0,0,4))
        selection.backgroundColourStyle = .Accent
        
        self.selectionIndicator = selection
        
        // Do any additional setup after loading the view.
        configureURLStack()
    }
    
    func configureURLStack() {
        
        
        safariButton.setImage(UIImage(named: "launch-safari"), forState: .Normal)
        safariButton.hidden = true
        
        urlTextField.delegate = self
        urlTextField.keyboardType = .URL
        urlTextField.returnKeyType = .Send
        urlTextField.autocapitalizationType = .None
        urlTextField.autocorrectionType = .No
        
        urlStack = CreateStackView([safariButton, urlTextField, refreshButton])
        urlStack.stackDistribution = .EqualSpacing
        urlStack.spacing = 8.0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        
        if let pageControlCell = cell as? JCPageControlCell {
            pageControlCell.backgroundColor = UIColor.clearColor()
            pageControlCell.contentView.backgroundColor = UIColor.clearColor()
            pageControlCell.titleLabel.textColor = MZThemeVendor.shared().defaultTheme?.colour(.LightText)
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegatePageControlLayout
    
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, titleFontForIndexPath indexPath: NSIndexPath) -> UIFont? {
        return MZThemeVendor.shared().defaultTheme?.font(.Title)
    }
    
}

extension MZURLDetailsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
}
