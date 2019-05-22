//
//  MovieDetailItemViewModel.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/15/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

struct ActorItemViewModel {
    let cast: Cast
    
    var actorName: String? {
        return cast.name
    }
    var profilePath: String? {
        return cast.profilePath
    }
    
    init(cast: Cast) {
        self.cast = cast
    }
}
