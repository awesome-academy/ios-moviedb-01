//
//  MainNavigator.swift
//  MovieApp
//
//  Created by nguyen.nam.khanh on 5/16/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

protocol MainNavigator {
    func toSearch()
    func toDetailMovie(movie: Movie)
    func toExtensionHome()
}

final class DefaultMainNavigator: MainNavigator {
    private let navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func toSearch() {
    }
    
    func toDetailMovie(movie: Movie) {
        print("id: \(movie.id)")
    }
    
    func toExtensionHome() {
    }
}
