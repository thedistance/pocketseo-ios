//
//  LinksDataSource.swift
//  MozQuito
//
//  Created by Josh Campion on 07/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

import ReactiveCocoa
import Components

class MozscapeLinksDataSource: ListDataSource<(urlRequest:String, nextPage:Bool),LinksOutput> {
    
    override init(viewModel: ContentLoadingViewModel<(urlRequest:String, nextPage:Bool),LinksOutput>, tableView: UITableView, animatesChanges: Bool = false) {
        super.init(viewModel: viewModel, tableView: tableView, animatesChanges: animatesChanges)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let showLoading = viewModel.loadedContent?.moreAvailable ?? false
        
        return super.tableView(tableView, numberOfRowsInSection: section) + (showLoading ? 1 : 0)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == viewModel.numberOfEntitiesInSection(indexPath.section) {
            
            let identifier = "LoadingCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier)!
            (cell.viewWithTag(1) as? UIActivityIndicatorView)?.startAnimating()
            return cell
        } else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
}