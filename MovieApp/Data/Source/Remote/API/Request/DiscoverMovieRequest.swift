//
//  DiscoverMovieRequest.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/23/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

final class DiscoverMovieRequest: BaseRequest {
    required init(genreIdList: [Int], page: Int) {
        var genreIdStringList = ""
        for (index, id) in genreIdList.enumerated() {
            genreIdStringList += index == 0 ? "\(id)" : ",\(id)"
        }
        let body: [String: Any] = [
            "with_genres": genreIdStringList,
            "page": page
        ]
        super.init(url: URLs.movieDiscoverApi, requestType: .get, body: body)
    }
}
