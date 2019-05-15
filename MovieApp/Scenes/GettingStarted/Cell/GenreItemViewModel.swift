//
//  GenreCellViewModel.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/14/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

struct GenreItemViewModel {
    let genre: Genre
    
    var title: String {
        return genre.name
    }
    
    init(genre: Genre) {
        self.genre = genre
    }
}
