//
//  ViewController.swift
//  swiftRxMoya
//
//  Created by Martin Conklin on 2016-08-21.
//  Copyright © 2016 Martin Conklin. All rights reserved.
//

import Moya
import Moya_ModelMapper
import UIKit
import RxCocoa
import RxSwift



class IssueViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    var provider: RxMoyaProvider<GitHub>!
    var latestRepositoryName: Observable<String> {
        return searchBar
            .rx_text
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    
    var issueTrackerModel: IssueTrackerModel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRx()
    }
    
    private func setupRx() {
        provider = RxMoyaProvider<GitHub>()
        
        issueTrackerModel = IssueTrackerModel(provider: provider, repositoryName: latestRepositoryName)
        
        issueTrackerModel
            .trackIssues()
            .bindTo(tableView.rx_itemsWithCellFactory) { (tableView, row, item) in
                let cell = tableView.dequeueReusableCellWithIdentifier("issueCell", forIndexPath: NSIndexPath(forRow: row, inSection: 0))
                cell.textLabel?.text = item.title
                
                return cell
        }
        .addDisposableTo(disposeBag)
        
        tableView
            .rx_itemSelected
            .subscribeNext { indexPath in
                if self.searchBar.isFirstResponder() == true {
                    self.view.endEditing(true)
                }
            }
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

