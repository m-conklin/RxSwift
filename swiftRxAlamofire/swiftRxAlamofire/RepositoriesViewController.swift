//
//  ViewController.swift
//  swiftRxAlamofire
//
//  Created by Martin Conklin on 2016-08-21.
//  Copyright © 2016 Martin Conklin. All rights reserved.
//

import UIKit
import ObjectMapper
import RxAlamofire
import RxCocoa
import RxSwift

class RepositoriesViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    var repositoryNetworkModel: RepositoryNetworkModel!
    
    var rx_searchBarText: Observable<String> {
        return searchBar
            .rx_text
            .filter { $0.characters.count > 0 }
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
    }
    
    private func setupRx() {
        repositoryNetworkModel = RepositoryNetworkModel(withNameObservable: rx_searchBarText)
        
        repositoryNetworkModel
            .rx_repositories
            .drive(tableView.rx_itemsWithCellFactory) { (tv, i, repository) in
                let cell = tv.dequeueReusableCellWithIdentifier("repositoryCell", forIndexPath: NSIndexPath(forRow: i, inSection: 0))
            cell.textLabel?.text = repository.name
                
            return cell
            }
            .addDisposableTo(disposeBag)
        
        repositoryNetworkModel
            .rx_repositories
            .driveNext { repositories in
                if repositories.count == 0 {
                    let alert = UIAlertController(title: ":(", message: "No repositories for this user.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    if self.navigationController?.visibleViewController?.isMemberOfClass(UIAlertController.self) != true {
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

