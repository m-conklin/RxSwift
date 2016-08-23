//
//  IssueTrackerModel.swift
//  swiftRxMoya
//
//  Created by Martin Conklin on 2016-08-21.
//  Copyright © 2016 Martin Conklin. All rights reserved.
//

import Foundation
import Moya
import Mapper
import Moya_ModelMapper
import RxOptional
import RxSwift

struct IssueTrackerModel
{
    let provider: RxMoyaProvider<GitHub>
    let repositoryName: Observable<String>
    
    func trackIssues() -> Observable<[Issue]> {
        return repositoryName
            .observeOn(MainScheduler.instance)
            .flatMapLatest { name -> Observable<Repository?> in
                print("Name: \(name)")
                return self
                    .findRepository(name)
            }
            .flatMapLatest { repository -> Observable<[Issue]?> in
                guard let repository = repository else { return Observable.just(nil) }
                
                print("Repository: \(repository.fullName)")
                return self.findIssues(repository)
            }
            .replaceNilWith([])
        
    }

    
    internal func findIssues(repository: Repository) -> Observable<[Issue]?> {
        return self.provider
            .request(GitHub.Issues(repositoryFullName: repository.fullName))
            .debug()
            .mapArrayOptional(Issue.self)
    }
    
    internal func findRepository(name: String) -> Observable<Repository?> {
        return self.provider
            .request(GitHub.Repo(fullname: name))
            .debug()
            .mapObjectOptional(Repository.self)
    }
}
