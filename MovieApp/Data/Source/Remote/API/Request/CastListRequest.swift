//
//  CastListRequest.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/15/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import ObjectMapper
import Alamofire

final class CastListRequest: BaseRequest {
    required init(movieId: Int) {
        super.init(url: URLs.movieApi + "/\(movieId)/credits", requestType: .get, body: [:])
    }
}
