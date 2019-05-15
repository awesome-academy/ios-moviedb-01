//
//  AppAssembler.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/17/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

protocol AppAssembler {
    func resolve(window: UIWindow) -> AppViewModel
    func resolve(window: UIWindow) -> AppNavigator
    func resolve() -> AppUseCase
}

extension AppAssembler {
    func resolve(window: UIWindow) -> AppViewModel {
        return AppViewModel(navigator: resolve(window: window), useCase: resolve())
    }
}

extension AppAssembler where Self: DefaultAssembler {
    func resolve(window: UIWindow) -> AppNavigator {
        return AppNavigatorImpl(assembler: self, window: window)
    }
    
    func resolve() -> AppUseCase {
        return AppUseCaseImpl(realm: resolve())
    }
}
