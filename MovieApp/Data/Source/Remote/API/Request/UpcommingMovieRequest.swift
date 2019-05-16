//
//  UpcommingMovieRequest.swift
//  MovieApp
//
//  Created by nguyen.nam.khanh on 5/16/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

final class UpcommingMovieRequest: BaseRequest {
    required init(page: Int) {
        let body: [String: Any]  = [
            "page": page,
            ]
        super.init(url: URLs.upcomingMovieApi, requestType: .get, body: body)
    }
}
