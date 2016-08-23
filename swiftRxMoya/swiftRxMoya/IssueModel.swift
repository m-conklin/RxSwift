//
//  IssueModel.swift
//  swiftRxMoya
//
//  Created by Martin Conklin on 2016-08-21.
//  Copyright © 2016 Martin Conklin. All rights reserved.
//

import Mapper

struct Issue: Mappable {
    
    let idenifier: Int
    let number: Int
    let title: String
    let body: String
    
    init(map: Mapper) throws {
        try idenifier = map.from("id")
        try number = map.from("number")
        try title = map.from("title")
        try body = map.from("body")
    }
}

