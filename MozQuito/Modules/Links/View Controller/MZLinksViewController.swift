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

class MZLinksViewController: ReactiveAppearanceViewController, ListLoadingTableView {
    
    typealias InputType = String
    typealias OutputType = [[MZMozscapeLinks]]
    typealias ValueType = MZMozscapeLinks

    var errorView = ErrorView(image: UIImage(named: "Error"), message: "")
    var emptyView = ErrorView(image: nil, message: "No Links Found")
    
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
            listDataSource = ListDataSource(viewModel: viewModel, tableView: tbv)
        }
    }
    
    var listDataSource:ListDataSource<String,[MZMozscapeLinks]>?
    
    var urlString:String? {
        didSet {
            viewModel?.refreshObserver.sendNext(urlString)
        }
    }
    
    @IBOutlet weak var tableView: UITableView?
    
    var refreshControl: UIRefreshControl?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        viewModel = MozscapeLinksViewModel(apiManager: APIManager(urlStore: LiveURLStore()))
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for v in [errorView, emptyView] {
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
            self.viewModel?.refreshObserver.sendNext(self.urlString)
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
    }

    func showErrorViewForError(error: NSError?) {
        
        errorView.label.text = ["Unable to download Links.",
            error?.localizedDescription,
            error?.localizedFailureReason,
            error?.localizedFailureReason]
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
}
