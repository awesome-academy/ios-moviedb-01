//
//  Genre.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/13/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import ObjectMapper
import RealmSwift

final class Genre: Object, Mappable {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var selected = false
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}
