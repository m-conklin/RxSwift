//
//  ViewController.swift
//  swiftRxSearch
//
//  Created by Martin Conklin on 2016-08-20.
//  Copyright © 2016 Martin Conklin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController  {
    
    var shownTones = [String]()
    let allTones = ["Anger", "Joy", "Sadness", "Fear", "Disgust"]
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        searchBar
            .rx_text
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { $0.characters.count > 0 }
            .subscribeNext { [unowned self] (query) in
                self.shownTones = self.allTones.filter { $0.hasPrefix(query) }
                self.tableView.reloadData()
        }
        .addDisposableTo(disposeBag)
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownTones.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tonePrototypeCell", forIndexPath: indexPath)
        cell.textLabel?.text = shownTones[indexPath.row]
        
        return cell
    }
}


