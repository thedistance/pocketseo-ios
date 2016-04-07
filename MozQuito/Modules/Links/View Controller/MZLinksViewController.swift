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
    }
    
    var listDataSource:MozscapeLinksDataSource?
    
    var urlString:String? {
        didSet {
            
            let validURL = !(urlString?.isEmpty ?? false)
            noInputView.hidden = validURL
            tableView?.hidden = !validURL
            
            if let request = urlString {
                viewModel?.refreshObserver.sendNext((urlRequest:request, nextPage:false))
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView?
    
    var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toCenter = [errorView, emptyView]
        
        tableView?.hidden = true
        
        for v in toCenter {
            v.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(v, centeredOn: view)
        }
        
        showErrorViewForError(nil)
        showNoContent(false)

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
        
        tableView?.addSubview(refresh)
        tableView?.estimatedRowHeight = 114
        tableView?.rowHeight = UITableViewAutomaticDimension
        
        self.refreshControl = refresh
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        showErrorViewForError(nil)
        showNoContent(false)
        
        if let selected = tableView?.indexPathForSelectedRow {
            tableView?.deselectRowAtIndexPath(selected, animated: true)
        }
    }

    func showErrorViewForError(error: NSError?) {
        
        errorView.label.text = ["Unable to download Links.",
            error?.localizedDescription,
            error?.localizedFailureReason,
            error?.localizedRecoverySuggestion]
            .flatMap({ $0 })
            .joinWithSeparator(" ")
        
        errorView.alpha = error == nil ? 0.0 : 1.0
        
    }
    
    func showNoContent(show:Bool) {
        emptyView.alpha = show ? 1.0 : 0.0
    }

}

extension MZLinksViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if var selectedLinkURL = viewModel?.entityForIndexPath(indexPath)?.canonicalURL?.absoluteString {
            
            if !(selectedLinkURL.hasPrefix("http://") || selectedLinkURL.hasPrefix("https://")) {
                selectedLinkURL = "http://" + selectedLinkURL
            }
            
            if let url = NSURL(string: selectedLinkURL) {
                
                let openEvent = AnalyticEvent(category: .DataRequest, action: .openInBrowser, label: url.absoluteString)
                AppDependencies.sharedDependencies().analyticsReporter?.sendAnalytic(openEvent)
                
                self.openURL(url, fromSourceItem: .View(self.view))
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let maxOffsetY =  scrollView.contentSize.height - scrollView.frame.size.height
        
        if maxOffsetY > 0 &&
            scrollView.contentOffset.y > maxOffsetY - 50 &&
            !(viewModel?.isLoading.value ?? true),
            let request = self.urlString {
            viewModel?.refreshObserver.sendNext((urlRequest: request, nextPage: true))
        }
    }
}
