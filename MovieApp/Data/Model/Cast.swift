//
//  Cast.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/13/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import ObjectMapper

struct Cast: Mappable {
    var personId = 0
    var name = ""
    var profilePath = ""
    
    required init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        personId <- map["id"]
        name <- map["name"]
        profilePath <- map["profilePath"]
    }
}
