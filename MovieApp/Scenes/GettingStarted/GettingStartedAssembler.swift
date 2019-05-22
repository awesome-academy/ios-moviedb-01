//
//  GettingStartedAssembler.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/17/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit

protocol GettingStartedAssembler {
    func resolve() -> GettingStartedViewController
    func resolve(viewController: UIViewController) -> GettingStartedViewModel
    func resolve(viewController: UIViewController) -> GettingStartedNavigator
    func resolve() -> GettingStartedUseCase
}

extension GettingStartedAssembler {
    func resolve() -> GettingStartedViewController {
        let vc = GettingStartedViewController.instantiate()
        let vm: GettingStartedViewModel = resolve(viewController: vc)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(viewController: UIViewController) -> GettingStartedViewModel {
        return GettingStartedViewModel(
            navigator: resolve(viewController: viewController),
            useCase: resolve()
        )
    }
}

extension GettingStartedAssembler where Self: DefaultAssembler {
    func resolve(viewController: UIViewController) -> GettingStartedNavigator {
        return DefaultGettingStartedNavigator(assembler: self, viewController: viewController)
    }
    
    func resolve() -> GettingStartedUseCase {
        return GettingStartedUseCaseImpl(repository: resolve(), realm: resolve())
    }
}
