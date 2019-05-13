//
//  Movie.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/13/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import ObjectMapper
import RealmSwift

struct Movie: Object, Mappable {
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var voteAverage = 0.0
    @objc dynamic var posterPath = ""
    @objc dynamic var releaseDate = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        voteAverage <- map["vote_average"]
        posterPath <- map["poster_path"]
        releaseDate <- map["release_date"]
    }
}
