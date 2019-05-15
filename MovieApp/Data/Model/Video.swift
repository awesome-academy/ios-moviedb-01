//
//  Video.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/15/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import ObjectMapper

struct Video: Mappable, Then {
    var key = ""
    var name = ""
    
    init?(map: Map) {
    }
    
    init() {
    }
    
    mutating func mapping(map: Map) {
        key <- map["key"]
        name <- map["name"]
    }
}
