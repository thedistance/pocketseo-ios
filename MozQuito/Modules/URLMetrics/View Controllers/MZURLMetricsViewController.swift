//
//  MZURLMetricsViewController.swift
//  MozQuito
//
//  Created by Josh Campion on 29/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit
import TheDistanceCore

import StackView
import Components
import ReactiveCocoa

class MZURLMetricsViewController: ReactiveAppearanceViewController {

    @IBOutlet weak var distanceView:MZDistanceView?
    @IBOutlet weak var noInputContainer:UIView?
    let noInputView = NoInputView()
    
    var urlMetricsViewModel:MozscapeViewModel? {
        didSet {
            if let vm = urlMetricsViewModel {
                vm.urlString <~ self.urlString.producer
            }
            mozscapeView?.dataStack.viewModel = urlMetricsViewModel
        }
    }
    
    var pageMetaDataViewModel:PageMetaDataViewModel? {
        didSet {
            if let vm = pageMetaDataViewModel {
                vm.urlString <~ self.urlString.producer
            }
            metaDataView?.metaStack.viewModel = pageMetaDataViewModel
        }
    }
    
    let urlString = MutableProperty<String?>(nil)
    
    @IBOutlet weak var contentToBottomConstraint:NSLayoutConstraint?
    //@IBOutlet weak var contentHeightConstraint:NSLayoutConstraint?
    @IBOutlet weak var metaDataView:MZPageMetaDataView?
    @IBOutlet weak var mozscapeView:MZMozscapeMetricsView?

    
    var metricsViews:[MZPanel?] {
        return [metaDataView, mozscapeView]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlStringProducer = urlString.producer
            .observeOn(UIScheduler())
            .map({ !($0?.isEmpty ?? true) })
            .startWithNext { (valid) in
                self.noInputView.hidden = valid
                self.contentToBottomConstraint?.priority = valid ? 990 : 740
                
                for p in self.metricsViews {
                    p?.hidden = !valid
                }
        }
        
        // hide the metrics stacks
        for sv in metricsViews {
            sv?.hidden = true
        }
        
        if let container = noInputContainer {
            container.addSubview(noInputView, centeredOn: container)
        }
        
        // bind the view models again if set before viewDidLoad
        if let vm = self.urlMetricsViewModel {
            mozscapeView?.dataStack.viewModel = vm
        }
        
        // bind the view model again if set before viewDidLoad
        if let vm = self.pageMetaDataViewModel {
            self.pageMetaDataViewModel = vm
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Configure TheDistanceStack based on context
        if extensionContext != nil {
            distanceView?.distanceStack = MZDistanceExtensionStack()
        } else {
            distanceView?.distanceStack = MZDistanceApplicationStack()
        }
        
        #if DEBUG || BETA_TESTING
            // set up the test view
            let tapper = UITapGestureRecognizer(target: self, action: #selector(MZURLMetricsViewController.logoTripleTapped(_:)))
            tapper.numberOfTouchesRequired = 1
            tapper.numberOfTapsRequired = 3
            distanceView?.distanceStack?.logoImageView.userInteractionEnabled = true
            distanceView?.distanceStack?.logoImageView.addGestureRecognizer(tapper)
        #endif
    }
    
    func logoTripleTapped(sender:AnyObject?) {
        
        let testVC = MZStoryboardLoader.instantiateViewControllerForIdentifier(.TestVC, bundle: NSBundle(forClass: TestAnalyticsViewController.self))
        let testNav = UINavigationController(rootViewController: testVC)
        
        if let dv = distanceView {
            self.presentViewController(testNav, fromSourceItem: .View(dv))
        }
    }

    func showErrors(errors:[NSError], forPanel panel:MZPanel?) {
        if let e = errors.first {
            (panel?.stack as? MZExpandingStack)?.state = .Error(e)
        }
    }
    
    func showTest() {
        MZStoryboardLoader.instantiateViewControllerForIdentifier(.TestVC, bundle: NSBundle(forClass: TestAnalyticsViewController.self))
    }
    
}
