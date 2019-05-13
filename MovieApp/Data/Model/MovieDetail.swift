//
//  MovieDetail.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/13/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import ObjectMapper

struct MovieDetail: Mappable {
    var id = 0
    var title = ""
    var voteAverage = 0.0
    var overview = ""
    var posterPath = ""
    var backDropPath = ""
    
    required init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        voteAverage <- map["vote_average"]
        overview <- map["overview"]
        posterPath <- map["poster_path"]
        backDropPath <- map["backdrop_path"]
    }
}
