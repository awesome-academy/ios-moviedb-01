//
//  SearchMovieRequest.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/23/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

final class SearchMovieRequest: BaseRequest {
    required init(query: String, page: Int) {
        let body: [String: Any] = [
            "query": query,
            "page": page
        ]
        super.init(url: URLs.searchMovieApi, requestType: .get, body: body)
    }
}
