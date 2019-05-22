//
//  MovieDetailAssembler.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/17/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit

protocol MovieDetailAssembler {
    func resolve(navigationController: UINavigationController, movie: Movie) -> MovieDetailViewController
    func resolve(navigationController: UINavigationController, movie: Movie) -> MovieDetailViewModel
    func resolve(navigationController: UINavigationController) -> MovieDetailNavigator
    func resolve() -> MovieDetailUseCase
}

extension MovieDetailAssembler {
    func resolve(navigationController: UINavigationController, movie: Movie) -> MovieDetailViewController {
        let vc = MovieDetailViewController.instantiate()
        let vm: MovieDetailViewModel = resolve(navigationController: navigationController, movie: movie)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController, movie: Movie) -> MovieDetailViewModel {
        return MovieDetailViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve(),
            movie: movie
        )
    }
}

extension MovieDetailAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> MovieDetailNavigator {
        return DefaultMovieDetailNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> MovieDetailUseCase {
        return MovieDetailUseCaseImpl(repository: resolve(), realm: resolve())
    }
}
