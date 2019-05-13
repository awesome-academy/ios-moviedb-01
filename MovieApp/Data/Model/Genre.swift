//
//  Genre.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/13/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import ObjectMapper
import RealmSwift

struct Genre: Object, Mappable {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}
