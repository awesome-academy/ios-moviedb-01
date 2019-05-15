//
//  GenreListRequest.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/13/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import ObjectMapper
import Alamofire

final class GenreListRequest: BaseRequest {
    required init() {
        super.init(url: URLs.genreListApi, requestType: .get, body: [:])
    }
}
