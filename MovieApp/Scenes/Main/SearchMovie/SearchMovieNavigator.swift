//
//  SearchMovieNavigator.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/21/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

protocol SearchMovieNavigator {
    func toMovieDetail(movie: Movie)
    func toBack()
}

final class DefaultSearchMovieNavigator: SearchMovieNavigator {
    private unowned let navigationController: UINavigationController
    private unowned let assembler: Assembler
    
    init(assembler: Assembler, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.assembler = assembler
    }
    
    func toMovieDetail(movie: Movie) {
        let vc: MovieDetailViewController = assembler.resolve(navigationController: navigationController,
                                                              movie: movie)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toBack() {
        navigationController.popViewController(animated: true)
    }
}
