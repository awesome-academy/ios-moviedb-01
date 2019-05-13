//
//  genreRepository.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/13/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import ObjectMapper

protocol GenreReponsitory {
    func getGenreList(input: GenreListRequest) -> Observable<[Genre]>
}

final class GenreReponsitoryImpl: GenreReponsitory {
    private var api: APIService!
    
    required init(api: APIService) {
        self.api = api
    }
    
    func getGenreList(input: GenreListRequest) -> Observable<[Genre]> {
        return api.request(input: input)
            .map({ (response: GenreListResponse) -> [Genre] in
                return response.genres
            })
    }
}
