//
//  RepositoryNetworkModel.swift
//  swiftRxAlamofire
//
//  Created by Martin Conklin on 2016-08-21.
//  Copyright © 2016 Martin Conklin. All rights reserved.
//

import ObjectMapper
import RxAlamofire
import RxCocoa
import RxSwift

struct RepositoryNetworkModel {
    
    lazy var rx_repositories: Driver<[Repository]> =  self.fetchRepositories()
    private var repositoryName: Observable<String>
    
    init(withNameObservable nameObservable: Observable<String>) {
        self.repositoryName = nameObservable
    }
    
    private func fetchRepositories() -> Driver<[Repository]> {
        return repositoryName
            .subscribeOn(MainScheduler.instance)
            .doOn(onNext: { response in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            })
        
            .observeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .flatMapLatest { text in
            return RxAlamofire
                .requestJSON(.GET, "https://api.github.com/users/\(text)/repos")
                .debug()
                .catchError { error in
                    return Observable.never()
            }
            }
            .observeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .map { (response, json) -> [Repository] in
                if let repos = Mapper<Repository>().mapArray(json) {
                    return repos
                } else {
                    return []
                }
            }
            
            .observeOn(MainScheduler.instance)
            .doOn(onNext: { response in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
            
            .asDriver(onErrorJustReturn: [])
    }}
