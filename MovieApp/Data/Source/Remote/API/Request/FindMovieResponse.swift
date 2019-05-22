//
//  FindMovieResponse.swift
//  MovieApp
//
//  Created by nguyen.nam.khanh on 5/16/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import ObjectMapper

final class FindMovieResponse:Mappable {
    var movie: Movie?
    
    required init(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        movie <- map[""]
    }
}
