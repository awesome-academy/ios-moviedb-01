//
//  AppViewModel.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/17/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import RealmSwift

struct AppViewModel {
    let navigator: AppNavigator
    let useCase: AppUseCase
}

extension AppViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
    }
    
    struct Output {
        let toScreen: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let toScreen = input.loadTrigger
            .map { _ in
                self.useCase.checkIfFirstRun()
            }
            .do(onNext: { firstRun in
                if firstRun {
                    self.useCase.setDidInit()
                }
            })
            .flatMap { _ -> Driver<Results<Genre>> in
                return self.useCase.getObjects(fileName: RealmConstansts.favoriteGenres)
                    .asDriverOnErrorJustComplete()
            }
            .do(onNext: { (results) in
                if !results.isEmpty {
                    self.navigator.toMain()
                } else {
                    self.navigator.toGettingStarted()
                }
            })
            .mapToVoid()
        
        return Output(toScreen: toScreen)
    }
}
