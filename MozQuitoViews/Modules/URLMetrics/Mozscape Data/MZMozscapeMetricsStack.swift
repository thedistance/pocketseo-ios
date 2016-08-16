//
//  MZMozscapeMetricsStack.swift
//  MozQuito
//
//  Created by Josh Campion on 18/02/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import StackView
import JCLocalization

import Components
import SwiftyJSON

import ReactiveCocoa
import ReactiveCocoaConvenience_Alamofire_SwiftyJSON

let LargeNumberFormatter:NSNumberFormatter = {

    let formatter = NSNumberFormatter()
    formatter.numberStyle = .DecimalStyle
    formatter.maximumFractionDigits = 0
    return formatter
    
}()

public class MZMozscapeIndexedStack:CreatedStack {
    
    let dateFormatter: NSDateFormatter = {
       
        let formatter = NSDateFormatter()
        formatter.timeStyle = .NoStyle
        formatter.dateStyle = .ShortStyle
        
        return formatter
    }()
    
    var dates:MZMozscapeMetrics? {
        didSet {
            [(lastDateLabel, dates?.lastIndexed), (nextDateLabel, nil)]
                .map({ ($0.0, $0.1 == nil ? NoValueString : self.dateFormatter.stringFromDate($0.1!)) })
                .forEach({ $0.0.text = $0.1 })
        }
    }
    
    var lastDateLabel:ThemeLabel {
        return lastStack.labels[1]
    }
    
    
    var nextDateLabel: ThemeLabel {
        return nextStack.labels[1]
    }
    
    let lastStack:GenericStringsStack<ThemeLabel>
    let nextStack:GenericStringsStack<ThemeLabel>
    
    init() {
        
        lastStack = GenericStringsStack<ThemeLabel>(strings: [LocalizedString(.URLMozscapeLastIndexedTitle), NoValueString])
        nextStack = GenericStringsStack<ThemeLabel>(strings: [LocalizedString(.URLMozscapeNextIndexedTitle), NoValueString])
        
        for l in [lastStack.labels[0], nextStack.labels[0]] {
            l.textStyle = .Caption
            l.textColourStyle = .SecondaryText
            l.setContentCompressionResistancePriority(755, forAxis: .Vertical)
        }
        
        for l in [lastStack.labels[1], nextStack.labels[1]] {
            l.textStyle = .Body1
            l.textColourStyle = .Text
            l.setContentCompressionResistancePriority(755, forAxis: .Vertical)
        }
        
        for l in nextStack.labels {
            l.textAlignment = .Right
            //temporary until paid version is available
            l.hidden = true
        }

        super.init(arrangedSubviews: [lastStack.stackView, nextStack.stackView])
        
        stack.stackDistribution = .FillEqually
        stack.axis = .Horizontal
        stack.spacing = 8.0
    }
    
}

class MZMozscapeMetricsStack: MZExpandingStack, ContentLoadingView {
    
    var viewModel:ContentLoadingViewModel<Void, MZMozscapeMetrics>? = nil {
        didSet {
            if let vm = viewModel {
                bindViewModel(vm)
            }
        }
    }
    
     var delegate:MZURLMetricsMozcapeStackDelegate?
    
    func bindViewModel(viewModel: ContentLoadingViewModel<Void, MZMozscapeMetrics>) {
        
        bindContentLoadingViewModel(viewModel)
        
        viewModel.contentChangesSignal
            .observeOn(UIScheduler())
            .observeNext { (info) in
                self.data = info
                self.indexedStack.dates = info
                
                self.state = .Success
        }
        
        viewModel.isLoading.producer.observeOn(UIScheduler()).startWithNext { (nowLoading) in
            if nowLoading {
                self.state = .Loading
            }
        }
    }
    
    var data:MZMozscapeMetrics? {
        didSet {
            
            let httpText:String?
            
            if let code = data?.HTTPStatusCode {
                
                switch code {
                case 0...13:
                    let keyString = "URLMozscapeStatusCode\(code)"
                    if let key = LocalizationKey(rawValue: keyString) {
                        httpText = LocalizedString(key)
                    } else {
                        httpText = nil
                    }
                    
                default:
                    httpText = String(format: LocalizedString(.URLMozscapeStatusCodeHTTP), code)
                }
            } else {
                httpText = nil
            }
            
            if let text = httpText {
                statusCodeLabel.text = text
            } else {
                statusCodeLabel.text = nil
            }
            
            pageAuthorityProgressView.setDValue(data?.pageAuthority)
            domainAuthorityProgressView.setDValue(data?.domainAuthority)
            spamScoreProgressView.setDValue(data?.spamScore)
            
            if let l = data?.establishedLinksRoot {
                rootLinksStack.labels[0].text = LargeNumberFormatter.stringFromNumber(l)
            } else {
                rootLinksStack.labels[0].text = NoValueString
            }
            
            if let l = data?.establishedLinksTotal {
                totalLinksStack.labels[0].text = LargeNumberFormatter.stringFromNumber(l)
            } else {
                totalLinksStack.labels[0].text = NoValueString
            }
        }
    }
    
    let statusCodeLabel = ThemeLabel()
    
    let authorityHeadingStack:StackView

    let pageAuthorityProgressView =  MZMetricProgressView()
    let domainAuthorityProgressView = MZMetricProgressView()
    let spamScoreProgressView = MZMetricProgressView()
    
    let linksStack:StackView
    
    let linksHeadingStack:StackView
    
    let rootLinksStack = GenericStringsStack<ThemeLabel>(strings: [NoValueString, LocalizedString(.URLMozscapeLinksRootDomain)])
    
    let totalLinksStack = GenericStringsStack<ThemeLabel>(strings: [NoValueString, LocalizedString(.URLMozscapeLinksTotalLinks)])
    
    let indexedStack = MZMozscapeIndexedStack()
    
    var authStack:StackView
    
    init() {
        
        // create the title views
        let titleImage = UIImage(named: "Moz Logo",
            inBundle: NSBundle(forClass: MZMozscapeMetricsStack.self),
            compatibleWithTraitCollection: nil)
        
        let titleImageButton = UIButton(type: .Custom) as UIButton
        titleImageButton.setImage(titleImage, forState: .Normal)
        titleImageButton.imageView?.contentMode = .ScaleAspectFit
        
        //        let titleImageView = UIImageView(image: titleImage)
//        titleImageView.contentMode = .ScaleAspectFit
        
        statusCodeLabel.textStyle = .Body1
        statusCodeLabel.textColourStyle = .SecondaryText
        
        // create the authority section
        
        let authorityTitleLabel = ThemeLabel()
        authorityTitleLabel.textStyle = .SubHeadline
        authorityTitleLabel.textColourStyle = .Text
        authorityTitleLabel.text = LocalizedString(.URLMozscapeAuthorityTitle)
        
        let authorityInfoButton = ThemeButton(type: .InfoDark)
        authorityInfoButton.setContentHuggingPriority(255, forAxis: .Horizontal)
        authorityInfoButton.tintColourStyle = .Accent
        
        authorityHeadingStack = CreateStackView([authorityTitleLabel])
        authorityHeadingStack.spacing = 8.0
        
        // ...create the authority charts
        
        pageAuthorityProgressView.total = 100
        domainAuthorityProgressView.total = 100
        spamScoreProgressView.total = 17
        
        let authInfo:[(progress:MZMetricProgressView, key:LocalizationKey)] =
        [
            (pageAuthorityProgressView, .URLMozscapeAuthorityPage),
            (domainAuthorityProgressView, .URLMozscapeAuthorityDomain)//, Until paid version becomes available
            //(spamScoreProgressView, .URLMozscapeAuthoritySpamScore)
            ]
            
        let authStacks:[StackView] = authInfo.map({ (progress:MZMetricProgressView, key:LocalizationKey) -> (MZMetricProgressView, ThemeLabel) in
            
            let titleLabel = ThemeLabel()
            titleLabel.setContentCompressionResistancePriority(760, forAxis: .Vertical)
            titleLabel.text = LocalizedString(key)
            titleLabel.textAlignment = .Center
            titleLabel.numberOfLines = 0
            titleLabel.textColourStyle = .Text
            titleLabel.textStyle = .Body1
            
            return (progress, titleLabel)
        }).map({
            
            var stack = CreateStackView([$0.0, $0.1])
            stack.axis = .Vertical
            stack.spacing = 4.0
            return stack
        })
        
        let ev1 = UIView()
        let ev2 = UIView()
        let ev3 = UIView()
        
        authStack = CreateStackView([ev1, authStacks[0].view, ev2, authStacks[1].view, ev3])
        authStack.axis = .Horizontal
        authStack.spacing = 16.0
        authStack.stackDistribution = .EqualCentering
        authStack.stackAlignment = .Fill
        
        // separate the sections
        
        let separator1 = ThemeView()
        separator1.backgroundColourStyle = .SecondaryText
        
        // create the Links Section
        
        let linksTitleLabel = ThemeLabel()
        linksTitleLabel.textStyle = .SubHeadline
        linksTitleLabel.textColourStyle = .Text
        linksTitleLabel.text = LocalizedString(.URLMozscapeLinksTitle)
        
        let linksInfoButton = ThemeButton(type: .InfoDark)
        linksInfoButton.setContentHuggingPriority(255, forAxis: .Horizontal)
        linksInfoButton.tintColourStyle = .Accent
        
        linksHeadingStack = CreateStackView([linksTitleLabel])
        linksHeadingStack.spacing = 8.0
        
        // create the content labels
        //rootLinksStack.labels[0],
        for l in [totalLinksStack.labels[0]] {
            l.textStyle = .Display1
            l.textColourStyle = .Text
            l.setContentHuggingPriority(255, forAxis: .Horizontal)
        }
        //rootLinksStack.labels[1],
        for l in [totalLinksStack.labels[1]] {
            l.textStyle = .Body1
            l.textColourStyle = .SecondaryText
        }
        
        //[rootLinksStack.stack, removed until paid version is available
        for var s in [totalLinksStack.stack] {
            s.axis = .Horizontal
            s.stackAlignment = .FirstBaseline
            s.spacing = 4.0
        }
        
        // separate the sections
        
        let separator2 = ThemeView()
        separator2.backgroundColourStyle = .SecondaryText
        
        for s in [separator1, separator2] {
            s.addConstraints(NSLayoutConstraint.constraintsToSize(s, toWidth: nil, andHeight: 1.0))
        }
        
        linksStack = CreateStackView([separator1,
            linksHeadingStack.view,
            //rootLinksStack.stackView,
            totalLinksStack.stackView,
            separator2])
        linksStack.axis = .Vertical
        linksStack.spacing = 16.0
        
        let collapsing = [statusCodeLabel,
            authorityHeadingStack.view,
            linksStack.view,
            indexedStack.stackView]
        
        for v in collapsing {
            v.hidden = true
        }
        
        
        
        super.init(titleView: titleImageButton, arrangedSubviews: [
            statusCodeLabel,
            authorityHeadingStack.view,
            authStack.view,
            linksStack.view,
            indexedStack.stackView])
        
        //Add target to titleImageButton
        titleImageButton.addTarget(self, action: #selector(MZMozscapeMetricsStack.mozLogoPressed(_:)), forControlEvents: .TouchUpInside)
        
        stack.axis = .Vertical
        stack.spacing = 16.0
        
        // constrain each auth stack to be equal widths
        
        for s in authStacks[1...1] {
            stack.view.addConstraint(NSLayoutConstraint(item: s.view,
                attribute: .Width,
                relatedBy: .Equal,
                toItem: authStacks[0].view,
                attribute: .Width,
                multiplier: 1.0,
                constant: 0.0))
        }
    }
    
     override func configureAsExpanded(expanded: Bool) {
        
        super.configureAsExpanded(expanded)
        
        let collapsing = [statusCodeLabel,
            authorityHeadingStack.view,
            linksStack.view,
            indexedStack.stackView]
        
        for v in collapsing {
            v.hidden = !expanded
        }
        
        stackView.setNeedsLayout()
    }
    
     func showErrorViewForError(error: NSError?) {
        if let err = error {
            self.state = .Error(err)
        }
    }
    
    @objc func mozLogoPressed(sender: UIButton) {
       
        self.delegate?.metricsMozscapePanelRequestOpenMozUrl(self, sender: sender)
    }
}