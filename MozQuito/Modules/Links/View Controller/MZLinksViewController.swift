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

class MZLinksViewController: ReactiveAppearanceViewController, ListLoadingTableView {
    
    typealias InputType = String
    typealias OutputType = [[MZMozscapeLinks]]
    typealias ValueType = MZMozscapeLinks
    
    var errorView = MZErrorView(image: UIImage(named: "Error"), message: "")
    var emptyView = MZErrorView(image: nil, message: LocalizedString(.LinksNoneFound))
    var noInputView = NoInputView()
    
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
        
        if let tbv = tableView {
            listDataSource = MozscapeLinksDataSource(viewModel: viewModel, tableView: tbv)
        }
        
        if #available( iOS 9, *) {
            // no need to re layout
        } else {
        
            viewModel.contentChangesSignal.observeOn(UIScheduler())
                .combinePrevious(LinksOutput(links: [], moreAvailable: true))
                .observeNext { (prev, new) in
                    
                    if prev.links.count == 0 {
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
    
    @IBOutlet weak var tableView: UITableView?
    
    var refreshControl: UIRefreshControl?
    
    var currentLifetime = MutableProperty<ViewLifetime>(.Init)
    var hasAppeared = MutableProperty<Bool>(false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentLifetime <~ lifetimeSignal
        hasAppeared <~ lifetimeSignal.filter { $0 == .DidAppear }
            .map { _ in true }
        
        let toCenter = [errorView, emptyView]
        
        for v in toCenter {
            v.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(v, centeredOn: view)
        }
        
        // hide all the views
        errorView.alpha = 0.0
        emptyView.alpha = 0.0
        showTableView(false)
        
        if let vm = self.viewModel {
            bindViewModel(vm)
        }
        
        let refresh = UIRefreshControl()
        refresh.rac_signalForControlEvents(.ValueChanged).toSignalProducer().startWithNext { _ in
            if let str = self.urlString {
                self.urlString = str
            } else {
                refresh.endRefreshing()
            }
        }
        
        searchConfiguration.producer.combinePrevious(LinkSearchConfiguration.defaultConfiguration())
            .startWithNext { (prev, new) in
                if prev != new,
                    let str = self.urlString {
                    self.urlString = str
                }
        }
        
        tableView?.addSubview(refresh)
        tableView?.estimatedRowHeight = 114
        tableView?.rowHeight = UITableViewAutomaticDimension
        
        self.refreshControl = refresh
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selected = tableView?.indexPathForSelectedRow {
            tableView?.deselectRowAtIndexPath(selected, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if #available( iOS 9, *) {
            // no layout needed
        } else {
            if currentLifetime.value == .WillAppear && !hasAppeared.value {
                tableView?.reloadData()
            }
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
        
        
        let sortOptions = LinkSortBy.allValues.map({ ($0.selectionKey, LocalizedString($0.localizationKey)) })
        
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
        
        if let str = urlString where !str.isEmpty {
            emptyView.alpha = show ? 1.0 : 0.0
            
            if show {
                showTableView(false)
            }
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if var selectedLinkURL = viewModel?.entityForIndexPath(indexPath)?.canonicalURL?.absoluteString {
            
            if !(selectedLinkURL.hasPrefix("http://") || selectedLinkURL.hasPrefix("https://")) {
                selectedLinkURL = "http://" + selectedLinkURL
            }
            
            if let url = NSURL(string: selectedLinkURL) {
                
                let openEvent = AnalyticEvent(category: .DataRequest, action: .openInBrowser, label: url.absoluteString)
                AppDependencies.sharedDependencies().analyticsReporter?.sendAnalytic(openEvent)
                
                let source = (tableView.cellForRowAtIndexPath(indexPath) as? LinksTableViewCell) ?? self.view
                
                self.openURL(url, fromSourceItem: .View(source!))
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let maxOffsetY =  scrollView.contentSize.height - scrollView.frame.size.height
        
        if maxOffsetY > 0 &&
            scrollView.contentOffset.y > maxOffsetY - 50 &&
            !(viewModel?.isLoading.value ?? true),
            let request = self.urlString
            {
            viewModel?.refreshObserver.sendNext((urlRequest: request, requestedParameters: self.searchConfiguration.value, nextPage: true))
        }
    }
}

extension MZLinksViewController: TDSelectionViewControllerDelegate {
    
    func selectionViewControllerRequestsCancel(selectionVC: TDSelectionViewController) {
        selectionVC.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func selectionViewControllerRequestsDismissal(selectionVC: TDSelectionViewController) {
        
        if let tbv = self.tableView {
            tbv.setContentOffset(CGPointMake(0, -tbv.contentInset.top), animated: false)
        }
        
        selectionVC.dismissViewControllerAnimated(true, completion: nil)
        
        // get the selection from the keys.
        if let selectedKeys = selectionVC.selectedKeys.allObjects as? [String],
            let config = LinkSearchConfiguration(selectionKeys: selectedKeys) {
            self.searchConfiguration.value = config
        }
    }
    
}
