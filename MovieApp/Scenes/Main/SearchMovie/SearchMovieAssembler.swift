//
//  SearchMovieAssembler.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/21/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit

protocol SearchMovieAssembler {
    func resolve(navigationController: UINavigationController) -> SearchMovieViewController
    func resolve(navigationController: UINavigationController) -> SearchMovieViewModel
    func resolve(navigationController: UINavigationController) -> SearchMovieNavigator
    func resolve() -> SearchMovieUseCase
}

extension SearchMovieAssembler {
    func resolve(navigationController: UINavigationController) -> SearchMovieViewController {
        let vc = SearchMovieViewController.instantiate()
        let vm: SearchMovieViewModel = resolve(navigationController: navigationController)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController) -> SearchMovieViewModel {
        return SearchMovieViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve()
        )
    }
}

extension SearchMovieAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> SearchMovieNavigator {
        return DefaultSearchMovieNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> SearchMovieUseCase {
        return SearchMovieUseCaseImpl(movieRepository: resolve(), genreRepository: resolve())
    }
}
