//
//  GettingStartedViewModel.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/13/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import RealmSwift

final class GettingStartedViewModel: ViewModelType {
    private let genreRepository: GenreReponsitory
    private let navigator: GettingStartedNavigator
    private var selectedGenres = Variable<[Genre]>([])
    
    init(genreRepository: GenreReponsitory, navigator: GettingStartedNavigator) {
        self.genreRepository = genreRepository
        self.navigator = navigator
    }
    
    func transform(input: GettingStartedViewModel.Input) -> GettingStartedViewModel.Output {
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        let genres = input.loadTrigger
            .flatMapLatest { _ in
                return self.genreRepository.getGenreList(input: GenreListRequest())
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
        
        let selected = input.selectTrigger
            .withLatestFrom(genres) { indexPath, genres -> IndexPath in
               let seleted = genres[indexPath.row]
                if self.selectedGenres.value.contains(seleted) {
                    self.selectedGenres.value.removeAll {
                        $0 == seleted
                    }
                } else {
                    self.selectedGenres.value.append(seleted)
                }
                return indexPath
            }
            .asDriver(onErrorJustReturn: IndexPath())
        
        let isDoneButtonEnabled = selectedGenres.asDriver()
            .map { selectedGenres in
                return !selectedGenres.isEmpty
            }
        
        let doneButton = input.doneButtonTrigger
            .asObservable()
            .flatMap { _ -> Observable<Void> in
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(self.selectedGenres.value, update: false)
                    }
                    self.navigator.toMain()
                    return Observable.just(())
                } catch {
                    return Observable.error(Errors.cantInitRealm)
                }
            }
            .trackError(errorTracker)
            .asDriver(onErrorJustReturn: ())
        
        return Output(genres: genres,
                      selected: selected,
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
        let doneButton: Driver<Void>
        let isDoneButtonEnabled: Driver<Bool>
        let error: Driver<Error>
        let indicator: Driver<Bool>
    }
}
