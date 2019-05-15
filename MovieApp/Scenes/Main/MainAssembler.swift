//
//  MainAssembler.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/19/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit

protocol MainAssembler {
    func resolve(navigationController: UINavigationController) -> MainViewController
    func resolve(navigationController: UINavigationController) -> MainViewModel
    func resolve(navigationController: UINavigationController) -> MainNavigator
    func resolve() -> MainUseCase
}

extension MainAssembler {
    func resolve(navigationController: UINavigationController) -> MainViewController {
        let vc = MainViewController.instantiate()
        let vm: MainViewModel = resolve(navigationController: navigationController)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController) -> MainViewModel {
        return MainViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve()
        )
    }
}

extension MainAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> MainNavigator {
        return DefaultMainNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> MainUseCase {
        return MainUseCaseImpl(repository: resolve())
    }
}
