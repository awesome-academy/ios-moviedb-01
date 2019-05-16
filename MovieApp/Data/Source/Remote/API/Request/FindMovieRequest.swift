//
//  FindMovieRequest.swift
//  MovieApp
//
//  Created by nguyen.nam.khanh on 5/16/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

final class FindMovieRequest: BaseRequest {
    required init(id: String) {
        let body: [String: Any]  = [
            "movie_id": id,
            ]
        super.init(url: URLs.movieApi, requestType: .get, body: body)
    }
}
