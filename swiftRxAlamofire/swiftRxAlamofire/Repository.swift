//
//  Repository.swift
//  swiftRxAlamofire
//
//  Created by Martin Conklin on 2016-08-21.
//  Copyright © 2016 Martin Conklin. All rights reserved.
//

import ObjectMapper

class Repository: Mappable {
    var identifier: Int!
    var language: String!
    var url: String!
    var name: String!
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        identifier <- map["id"]
        language <- map["language"]
        url <- map["url"]
        name <- map["name"]
    }
}
