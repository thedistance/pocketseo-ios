//
//  MZLinksViewController.swift
//  MozQuito
//
//  Created by Ashhad Syed on 06/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit

import Components
import ReactiveCocoa
import TheDistanceCore
import JCLocalization
import SelectionViewController

class MZLinksViewController: ReactiveAppearanceViewController, ListLoadingTableView {
    
    typealias InputType = String
    typealias OutputType = [[MZMozscapeLinks]]
    typealias ValueType = MZMozscapeLinks
    
    @IBOutlet weak var mozLogoButton: UIButton?
    
    var errorView = MZErrorView(image: UIImage(named: "Error"), message: "")
    var emptyView = MZErrorView(image: nil, message: LocalizedString(.LinksNoneFound))
    var noInputView = NoInputView()
    
    let headerImage:UIImage? = UIImage(named: "Moz Logo",
                                      inBundle: NSBundle(forClass: MZMozscapeMetricsStack.self),
                                      compatibleWithTraitCollection: nil)
    
    var viewModel:MozscapeLinksViewModel? {
        didSet {
            if let vm = viewModel {
                bindViewModel(vm)
            } else {
                listDataSource = nil
                tableView?.reloadData()
            }
        }
    }
    
    func bindViewModel(viewModel:MozscapeLinksViewModel) {
        
        bindListLoadingTableViewModel(viewModel)
        
        viewModel.viewLifetime <~ lifetimeSignal
        viewModel.urlString <~ urlString
        viewModel.searchConfiguration <~ searchConfiguration
        
        viewModel.refreshSignal.observeOn(UIScheduler())
        .startWithNext { (nextPage) in
            if !(nextPage ?? false) {
                if let tbv = self.tableView,
                    let refreshControl = self.refreshControl {
                    // adjust the scroll to show the refresh control
                    tbv.setContentOffset(CGPointMake(0, -refreshControl.frame.size.height), animated: true)
                }
            }
        }
        
        if let tbv = tableView {
            listDataSource = MozscapeLinksDataSource(viewModel: viewModel, tableView: tbv)
        }
        
        if #available( iOS 9, *) {
            // no need to re layout
        } else {
            
            viewModel.contentChangesSignal.observeOn(UIScheduler())
                .combinePrevious(LinksOutput(currentContent: [], moreAvailable: true))
                .observeNext { (prev, new) in
                    
                    if prev.currentContent.count == 0 {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            if let tbv = self.tableView {
                                tbv.beginUpdates()
                                tbv.reloadRowsAtIndexPaths(tbv.indexPathsForVisibleRows ?? [], withRowAnimation: UITableViewRowAnimation.None)
                                tbv.endUpdates()
                            }
                        })
                    }
            }
        }
    }
    
    var listDataSource:MozscapeLinksDataSource?
    
    var searchConfiguration = MutableProperty<LinkSearchConfiguration>(LinkSearchConfiguration.defaultConfiguration())
    
    var urlString = MutableProperty<String?>(nil)
    
    var validURLString = MutableProperty<Bool>(false)
    
    /*
     var urlString:String? {
     didSet {
     
     let validURL = !(urlString?.isEmpty ?? false)
     noInputView.hidden = validURL
     
     showNoContent(false)
     showErrorViewForError(nil)
     showTableView(validURL)
     
     if let request = urlString
     {
     viewModel?.refreshObserver.sendNext((urlRequest:request, requestedParameters: searchConfiguration.value, nextPage:false))
     }
     }
     }
     */
    
    @IBOutlet weak var tableView: UITableView?
    
    var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mozLogoButton?.addTarget(self, action: #selector(MZLinksViewController.headerImageButtonPressed(_:)), forControlEvents: .TouchUpInside)
        
        // configure reloading properties
        validURLString <~ urlString.producer.map { $0?.isEmpty ?? true }.map { !$0 }
        
        validURLString.producer
            .observeOn(UIScheduler())
            .startWithNext { (valid) in
                self.showTableView(valid)
        }
        
        
        // configure UIViews not added in the storyboard
        let toCenter = [errorView, emptyView]
        
        for v in toCenter {
            v.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(v, centeredOn: view)
        }
        
        // hide all the views
        errorView.alpha = 0.0
        emptyView.alpha = 0.0
        showTableView(false)
        
        // bind the view model again if set before viewDidLoad
        if let vm = self.viewModel {
            bindViewModel(vm)
        }
        
        // add pull to refresh
        let refresh = UIRefreshControl()
        refresh.rac_signalForControlEvents(.ValueChanged).toSignalProducer().startWithNext { _ in
            if self.validURLString.value {
                // pull to refresh reloads
                self.viewModel?.refreshObserver.sendNext(false)
            } else {
                refresh.endRefreshing()
            }
        }
        self.refreshControl = refresh
        
        tableView?.addSubview(refresh)
        
        let headerView = UIView()
        
        headerView.backgroundColor = UIColor(red: 36/255, green: 171/255, blue: 226/255, alpha: 1)
        
        //        headerView.contentMode = .ScaleAspectFit
        let headerImageButton = UIButton(type: .Custom) as UIButton
        headerImageButton.setImage(headerImage, forState: .Normal)
        headerImageButton.imageView?.contentMode = .ScaleAspectFit
        headerImageButton.frame = CGRectMake(0, 0, headerImage?.size.width ?? 200, headerImage?.size.height ?? 100)
        headerImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        headerImageButton.addTarget(self, action: #selector(MZLinksViewController.headerImageButtonPressed(_:)), forControlEvents: .TouchUpInside)
        
        headerView.addConstraints([
            NSLayoutConstraint(item: headerView,
                attribute: .CenterX,
                relatedBy: .Equal,
                toItem: headerImageButton,
                attribute: .CenterX,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: headerView,
                attribute: .CenterY,
                relatedBy: .Equal,
                toItem: headerImageButton,
                attribute: .CenterY,
                multiplier: 1,
                constant: 0)
            ])
        
        headerView.addSubview(headerImageButton)
        
        tableView?.tableHeaderView = headerView
        tableView?.tableHeaderView?.backgroundColor = UIColor(red: 36/255, green: 171/255, blue: 226/255, alpha: 1)
        tableView?.tableHeaderView?.frame = CGRectMake(0, 0, self.view.frame.size.width, headerImage?.size.height ?? 100)
        
        // make table view autosizing
        tableView?.estimatedRowHeight = 114
        tableView?.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel?.isLoading.value ?? false {
            self.refreshControl?.beginRefreshing()
        } else {
            self.refreshControl?.endRefreshing()
            self.tableView?.contentInset = UIEdgeInsetsZero
        }
    }
    
    func filterTapped(sender:AnyObject) {
        
        if let buttonSender = sender as? UIButton {
            showFilterOptions(.View(buttonSender))
        } else if let bbiSender = sender as? UIBarButtonItem {
            showFilterOptions(.BarButton(bbiSender))
        }
    }
    
    func showFilterOptions(sender:UIPopoverSourceType) {
        
        guard let selectionVC = MZStoryboardLoader.instantiateViewControllerForIdentifier(.LinksSelectionVC) as? MZLinksSelectionViewController else { return }
        
        
        let sortOptions = LinkSortBy.freeValues.map({ ($0.selectionKey, LocalizedString($0.localizationKey)) })
        
        let targetOptions = LinkTarget.allValues.map({ ($0.selectionKey, LocalizedString($0.localizationKey)) })
        
        let sourceOptions = LinkSource.allValues.map({ ($0.selectionKey, LocalizedString($0.localizationKey)) })
        
        let typeOptions = LinkType.allValues.map({ ($0.selectionKey, LocalizedString($0.localizationKey)) })
        
        let allOptions = [sortOptions, targetOptions, sourceOptions, typeOptions]
        
        // a dictionary of all Key-Value pairs
        let options = allOptions.map { Dictionary($0) }
            .reduce([String:String](), combine: +)
        
        // an array of just keys
        let order = allOptions.map { $0.map { $0.0 } }
        
        selectionVC.setOptions(options, withDetails: nil, orderedAs: order)
        selectionVC.sectionTitles = [
            LinkSortBy.titleKey,
            LinkTarget.titleKey,
            LinkSource.titleKey,
            LinkType.titleKey,
            ].map { LocalizedString($0) }
        selectionVC.selectedKeys = NSMutableSet(array: searchConfiguration.value.selectionKeys)
        selectionVC.title = LocalizedString(.LinksFilter)
        
        let navVC = UINavigationController(navigationBarClass: ThemeNavigationBar.self, toolbarClass: ThemeToolbar.self)
        navVC.navigationBar.translucent = false
        (navVC.navigationBar as? ThemeNavigationBar)?.barTintColourStyle = .Main
        (navVC.navigationBar as? ThemeNavigationBar)?.tintColourStyle = .LightText
        (navVC.navigationBar as? ThemeNavigationBar)?.textColourStyle = .LightText
        
        navVC.viewControllers = [selectionVC]
        navVC.modalInPopover = true
        navVC.modalPresentationStyle = .Popover
        
        selectionVC.modalInPopover = true
        selectionVC.modalPresentationStyle = .Popover
        selectionVC.delegate = self
        
        presentViewController(navVC, fromSourceItem: sender)
    }
    
    func showErrorViewForError(error: NSError?) {
        
        errorView.label.text = ["Unable to download Links.",
            error?.localizedDescription,
            error?.localizedFailureReason,
            error?.localizedRecoverySuggestion]
            .flatMap({ $0 })
            .joinWithSeparator(" ")
        
        errorView.alpha = error == nil ? 0.0 : 1.0
        
        if error != nil {
            showTableView(false)
        }
    }
    
    func showNoContent(show:Bool) {
        
        emptyView.alpha = validURLString.value && show ? 1.0 : 0.0
        
        if show {
            showTableView(false)
        }
    }
    
    func showTableView(show:Bool) {
        tableView?.separatorStyle = show ? .SingleLine : .None
    }
    
}

extension MZLinksViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return headerImage?.size.height ?? 0
//    }
//
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        
//       // let headerImageView = UIImageView(image: headerImage)
//        
//        headerView.backgroundColor = UIColor(red: 36/255, green: 171/255, blue: 226/255, alpha: 1)
//        
////        headerView.contentMode = .ScaleAspectFit
//        let headerImageButton = UIButton(type: .Custom) as UIButton
//        headerImageButton.setImage(headerImage, forState: .Normal)
//        headerImageButton.imageView?.contentMode = .ScaleAspectFit
//        headerImageButton.frame = CGRectMake(0, 0, headerImage?.size.width ?? 200, headerImage?.size.height ?? 100)
//        headerImageButton.translatesAutoresizingMaskIntoConstraints = false
//        
//        headerImageButton.addTarget(self, action: #selector(MZLinksViewController.headerImageButtonPressed(_:)), forControlEvents: .TouchUpInside)
//        
//        headerView.addConstraints([
//            NSLayoutConstraint(item: headerView,
//                attribute: .CenterX,
//                relatedBy: .Equal,
//                toItem: headerImageButton,
//                attribute: .CenterX,
//                multiplier: 1,
//                constant: 0),
//            NSLayoutConstraint(item: headerView,
//                attribute: .CenterY,
//                relatedBy: .Equal,
//                toItem: headerImageButton,
//                attribute: .CenterY,
//                multiplier: 1,
//                constant: 0)
//            ])
//        
//        headerView.addSubview(headerImageButton)
//        
//        return headerView
//    }
    
    func headerImageButtonPressed(sender: UIButton){
        
        if let mozUrl = NSURL(string: LocalizedString(.MozWebsiteURL)) {
            
            let openEvent = AnalyticEvent(category: .DataRequest, action: .openInBrowser, label: mozUrl.absoluteString)
            AppDependencies.sharedDependencies().analyticsReporter?.sendAnalytic(openEvent)
            
            self.openURL(mozUrl, fromSourceItem: .View(sender))
            
        }
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if var selectedLinkURL = viewModel?.entityForIndexPath(indexPath)?.canonicalURL?.absoluteString {
            
            if !(selectedLinkURL.hasPrefix("http://") || selectedLinkURL.hasPrefix("https://")) {
                selectedLinkURL = "http://" + selectedLinkURL
            }
            
            if let url = NSURL(string: selectedLinkURL) {
                
                let source = (tableView.cellForRowAtIndexPath(indexPath) as? LinksTableViewCell) ?? self.view
                
                self.openURL(url, fromSourceItem: .View(source!))
                
                let openEvent = AnalyticEvent(category: .DataRequest, action: .openInBrowser, label: url.absoluteString)
                AppDependencies.sharedDependencies().analyticsReporter?.sendAnalytic(openEvent)
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        })
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let maxOffsetY =  scrollView.contentSize.height - scrollView.frame.size.height
        
        if maxOffsetY > 0 &&
            scrollView.contentOffset.y > maxOffsetY - 50 &&
            !(viewModel?.isLoading.value ?? true) &&
            validURLString.value
        {
            viewModel?.refreshObserver.sendNext(true)
        }
    }
}

extension MZLinksViewController: TDSelectionViewControllerDelegate {
    
    func selectionViewControllerRequestsCancel(selectionVC: TDSelectionViewController) {
        selectionVC.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func selectionViewControllerRequestsDismissal(selectionVC: TDSelectionViewController) {
        
        let hasChanged = self.searchConfiguration.value != LinkSearchConfiguration(selectionKeys: (selectionVC.selectedKeys.allObjects as? [String])!)
        
        // get the selection from the keys.
        if let selectedKeys = selectionVC.selectedKeys.allObjects as? [String],
            let config = LinkSearchConfiguration(selectionKeys: selectedKeys) {
            
            if hasChanged{
                self.searchConfiguration.value = config
            }
        }
        
        selectionVC.dismissViewControllerAnimated(true) {
            if hasChanged {
            self.refreshControl?.beginRefreshing()
            }
        }
        
        
    }
}
