//
//  GenreListResponse.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/13/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import ObjectMapper

final class GenreListResponse: Mappable {
    var genres = [Genre]()
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        genres <- map["genres"]
    }
}
