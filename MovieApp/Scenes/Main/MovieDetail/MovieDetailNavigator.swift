//
//  MovieDetailNavigator.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/15/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

protocol MovieDetailNavigator {
    func toActor(cast: Cast)
    func back()
}

final class DefaultMovieDetailNavigator: MovieDetailNavigator {
    private unowned let navigationController: UINavigationController
    private unowned let assembler: Assembler
    
    init(assembler: Assembler, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.assembler = assembler
    }
    
    func toActor(cast: Cast) {
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
}
