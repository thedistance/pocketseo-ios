//
//  MZPageMetaDataStack.swift
//  MozQuito
//
//  Created by Josh Campion on 29/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

import TheDistanceCore
import StackView
import JCLocalization

import Components
import SwiftyJSON

import ReactiveCocoa
import ReactiveCocoaConvenience_Alamofire_SwiftyJSON

public class MZPageMetaDataStack: MZExpandingStack, ContentLoadingView {
    
    var viewModel:ContentLoadingViewModel<Void, MZPageMetaData>? = nil {
        didSet {
            if let vm = viewModel {
                bindViewModel(vm)
            }
        }
    }
    
    func bindViewModel(viewModel: ContentLoadingViewModel<Void, MZPageMetaData>) {
        
        bindContentLoadingViewModel(viewModel)
        
        viewModel.contentChangesSignal
            .observeOn(UIScheduler())
            .observeNext { (pageMeta) in
                self.pageMetaData = pageMeta
                self.state = .Success
        }
        
        viewModel.isLoading.producer.observeOn(UIScheduler()).startWithNext { (nowLoading) in
            if nowLoading {
                self.state = .Loading
            }
        }
    }
    
    static let dateFormatter:NSDateFormatter = {
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .MediumStyle
        
        return formatter
    }()
    
    let pageTitleStack = MZMetaDataStack(titleKey: .URLPageMetaDataPageTitle)
    let canonicalStack = MZMetaDataStack(titleKey: .URLPageMetaDataCanonicalURL)
    let descriptionStack = MZMetaDataStack(titleKey: .URLPageMetaDataMetaDescription)
    let h1Stack = MZMetaDataStack(titleKey: .URLPageMetaDataH1Tags)
    let h2Stack = MZMetaDataStack(titleKey: .URLPageMetaDataH2Tags)
    private(set) var usingSSLStack:StackView
    
    private(set) var detailsStack:StackView
    private(set) var footerStack:StackView
    
    let usingSSLTitleLabel = ThemeLabel()
    let usingSSLLabel = ThemeLabel()
    let usingSSLImageView = ThemeImageView()
    let responseURLLabel = ThemeLabel()
    let refreshDateLabel = ThemeLabel()
    
    public var pageMetaData:MZPageMetaData? {
        didSet {
            
            let h1Text = pageMetaData?.htmlMetaData.h1Tags.joinWithSeparator(" \u{2022} ")
            let h2Text = pageMetaData?.htmlMetaData.h2Tags.joinWithSeparator(" \u{2022} ")
            
            let stackValues:[(stack:MZMetaDataStack, value:String?, charactercCount:Int?)] = [
                (pageTitleStack, pageMetaData?.htmlMetaData.title, pageMetaData?.htmlMetaData.titleCharacterCount),
                (canonicalStack, pageMetaData?.htmlMetaData.canonicalURL?.absoluteString, pageMetaData?.htmlMetaData.canonicalURLCharacterCount),
                (descriptionStack, pageMetaData?.htmlMetaData.description, pageMetaData?.htmlMetaData.descriptionCharacterCount),
                (h1Stack, h1Text, pageMetaData?.htmlMetaData.h1TagsCharacterCount),
                (h2Stack, h2Text, pageMetaData?.htmlMetaData.h2TagsCharacterCount),
            ]
            
            for (stack, value, count) in stackValues {
                stack.value = value
                stack.characterCount = count
            }
            
            if let date = pageMetaData?.requestDate {
                refreshDateLabel.text = self.dynamicType.dateFormatter.stringFromDate(date)
            } else {
                refreshDateLabel.text = nil
            }
            
            if let str = pageMetaData?.responseURL.absoluteString {
                responseURLLabel.text = str
            } else {
                responseURLLabel.text = nil
            }
            
            if pageMetaData?.usingSSL ?? false {
                usingSSLLabel.text = LocalizedString(.URLPageMetaDataUsingSSL)
                usingSSLImageView.image = UIImage(named: "ic_lock_outline")
            } else {
                usingSSLLabel.text = LocalizedString(.URLPageMetaDataNotUsingSSL)
                usingSSLImageView.image = UIImage(named: "ic_lock_open")
            }
        }
    }
    
    init() {
        
        var innerSSLStack = CreateStackView([usingSSLTitleLabel, usingSSLLabel])
        innerSSLStack.axis = .Vertical
        innerSSLStack.spacing = 8.0
        
        usingSSLStack = CreateStackView([innerSSLStack.view, usingSSLImageView])
        
        detailsStack = CreateStackView([pageTitleStack.stackView,
            canonicalStack.stackView,
            descriptionStack.stackView,
            h1Stack.stackView,
            h2Stack.stackView,
            usingSSLStack.view])
        footerStack = CreateStackView([responseURLLabel, refreshDateLabel])
        
        usingSSLStack.view.hidden = true
        
        let titleLabel = ThemeLabel()
        titleLabel.textStyle = .Title
        titleLabel.textColourStyle = .Text
        titleLabel.textAlignment = .Center
        titleLabel.text = LocalizedString(.URLPageMetaDataHeadline)
        
        // init as collapsed
        canonicalStack.stackView.hidden = true
        h1Stack.stackView.hidden = true
        h2Stack.stackView.hidden = true
        usingSSLStack.view.hidden = true
        footerStack.view.hidden = true
        
        super.init(titleView: titleLabel, arrangedSubviews: [detailsStack.view, footerStack.view])
    }
    
    override func configureStack() {
        
        super.configureStack()
        
        // configure the stacks
        footerStack.axis = .Horizontal
        footerStack.spacing = 8.0
        footerStack.stackDistribution = .EqualSpacing
        
        detailsStack.axis = .Vertical
        detailsStack.spacing = 16.0
        
        // configure the labels
        responseURLLabel.textStyle = .Caption
        responseURLLabel.textColourStyle = .SecondaryText
        
        refreshDateLabel.textStyle = .Caption
        refreshDateLabel.textColourStyle = .SecondaryText
        
        usingSSLTitleLabel.textStyle = .Caption
        usingSSLTitleLabel.textColourStyle = .SecondaryText
        
        usingSSLLabel.textStyle = .Body1
        usingSSLLabel.textColourStyle = .Text
        
        usingSSLImageView.tintColourStyle = .SecondaryText
        usingSSLImageView.contentMode = .ScaleAspectFit
        
        responseURLLabel.numberOfLines = 0
        usingSSLTitleLabel.numberOfLines = 0
        
        usingSSLTitleLabel.text = LocalizedString(.URLPageMetaDataSSLTitle)
        usingSSLStack.stackDistribution = .EqualSpacing
        
        responseURLLabel.setContentCompressionResistancePriority(755, forAxis: .Vertical)
        refreshDateLabel.setContentCompressionResistancePriority(760, forAxis: .Horizontal)
        refreshDateLabel.setContentHuggingPriority(255, forAxis: .Horizontal)
    }
    
    public override func configureAsExpanded(expanded: Bool) {
        
        super.configureAsExpanded(expanded)
        
        canonicalStack.stackView.hidden = !expanded
        h1Stack.stackView.hidden = !expanded
        h2Stack.stackView.hidden = !expanded
        usingSSLStack.view.hidden = !expanded
        footerStack.view.hidden = !expanded
    }
    
    public func showErrorViewForError(error: NSError?) {
        
        if let err = error {
            self.state = .Error(err)
        } else {
            // Check what to do here
        }
    }
    
}
