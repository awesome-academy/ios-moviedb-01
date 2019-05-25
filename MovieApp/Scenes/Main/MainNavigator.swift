//
//  MainNavigator.swift
//  MovieApp
//
//  Created by nguyen.nam.khanh on 5/16/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

protocol MainNavigator {
    func toSearch()
    func toMovieDetail(movie: Movie)
    func toHomeExtension()
}

final class DefaultMainNavigator: MainNavigator {
    private unowned let navigationController: UINavigationController
    private unowned let assembler: Assembler
    
    init(assembler: Assembler, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.assembler = assembler
    }
    
    func toSearch() {
        let vc: SearchMovieViewController = assembler.resolve(navigationController: navigationController)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toMovieDetail(movie: Movie) {
        let vc: MovieDetailViewController = assembler.resolve(navigationController: navigationController,
                                                              movie: movie)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toHomeExtension() {
    }
}
