//
//  URLs.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/13/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import Foundation

enum URLs {
    static let baseUrl = "https://api.themoviedb.org/3"
    static let genreListApi = baseUrl + "/genre/movie/list"
    static let movieApi = baseUrl + "/movie"
    static let personApi = baseUrl + "/person"
    static let searchMovieApi = baseUrl + "/search/movie"
    static let movieDiscoverApi = baseUrl + "/discover/movie"
    static let upcomingMovieApi = movieApi + "/upcoming"
    static let popularMovieApi = movieApi + "/popular"
    static let posterApi = "https://image.tmdb.org/t/p/w300"
    static let youtubeEmbed = "https://www.youtube.com/embed"
}
