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
    private unowned let navigationController: UINavigationController
    private unowned let assembler: Assembler
    
    init(assembler: Assembler, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.assembler = assembler
    }
    
    func toSearch() {
    }
    
    func toDetailMovie(movie: Movie) {
        let vc: MovieDetailViewController = assembler.resolve(navigationController: navigationController,
                                                              movie: movie)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toExtensionHome() {
    }
}
