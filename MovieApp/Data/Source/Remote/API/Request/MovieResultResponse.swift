//
//  MovieResultResponse.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/23/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import ObjectMapper

final class MovieResultResponse: Mappable {
    var totalPages = 0
    var movies = [Movie]()
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        totalPages <- map["total_pages"]
        movies <- map["results"]
    }
}
