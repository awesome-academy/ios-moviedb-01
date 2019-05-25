//
//  GettingStartedViewModel.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/13/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import RealmSwift

final class GettingStartedViewModel: ViewModelType {
    private let useCase: GettingStartedUseCase
    private let navigator: GettingStartedNavigator
    private var selectedGenres = BehaviorRelay<[Genre]>(value: [])
    
    init(navigator: GettingStartedNavigator, useCase: GettingStartedUseCase) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func transform(input: GettingStartedViewModel.Input) -> GettingStartedViewModel.Output {
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        let genres = input.loadTrigger
            .flatMapLatest { _ in
                return self.useCase.getGenreList()
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
            .do(onNext: { genres in
                self.selectedGenres.accept(genres)
            })
        
        let selected = input.selectTrigger
            .withLatestFrom(selectedGenres.asDriver()) { indexPath, genres -> IndexPath in
                genres[indexPath.row].selected = !genres[indexPath.row].selected
                self.selectedGenres.accept(genres)
                return indexPath
            }
            .asDriver(onErrorJustReturn: IndexPath())
        
        let isDoneButtonEnabled = selectedGenres.asDriver()
            .map { selectedGenres in
                return !selectedGenres.isEmpty
            }
        
        let doneButton = input.doneButtonTrigger
            .withLatestFrom(selectedGenres.asDriver())
            .flatMap { genres -> Driver<Void> in
                return self.useCase.saveObjects(objects: genres)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
            .do(onNext: { _ in
                self.navigator.toMain()
            })
        
        return Output(genres: genres,
                      selected: selected,
                      selectedGenres: selectedGenres.asDriver(),
                      doneButton: doneButton,
                      isDoneButtonEnabled: isDoneButtonEnabled,
                      error: errorTracker.asDriver(),
                      indicator: activityIndicator.asDriver())
    }
}

extension GettingStartedViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let selectTrigger: Driver<IndexPath>
        let doneButtonTrigger: Driver<Void>
    }
    
    struct Output {
        let genres: Driver<[Genre]>
        let selected: Driver<IndexPath>
        let selectedGenres: Driver<[Genre]>
        let doneButton: Driver<Void>
        let isDoneButtonEnabled: Driver<Bool>
        let error: Driver<Error>
        let indicator: Driver<Bool>
    }
}
