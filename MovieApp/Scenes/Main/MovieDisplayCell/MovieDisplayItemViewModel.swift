//
//  MovieDisplayItemViewModel.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/19/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

struct MovieDisplayItemViewModel {
    let movie: Movie
    
    var title: String? {
        return movie.title
    }
    var voteAverage: Double? {
        return movie.voteAverage
    }
    var posterPath: String? {
        return movie.posterPath
    }
    
    init(movie: Movie) {
        self.movie = movie
    }
}
