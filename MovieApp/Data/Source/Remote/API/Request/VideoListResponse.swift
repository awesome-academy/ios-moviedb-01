//
//  VideoListResponse.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/15/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import ObjectMapper

final class VideoListResponse: Mappable {
    var videos = [Video]()
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        videos <- map["results"]
    }
}
