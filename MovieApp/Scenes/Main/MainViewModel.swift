//
//  MainViewModel.swift
//  MovieApp
//
//  Created by nguyen.nam.khanh on 5/16/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import RealmSwift

final class MainViewModel: ViewModelType {
    private let navigator: MainNavigator
    private let movieRepository: MovieRepository
    private let popularTotalMovies = BehaviorRelay<[Movie]>(value: [])
    private let upcommingTotalMovies = BehaviorRelay<[Movie]>(value: [])
    private var upcommingPage = BehaviorRelay<Int>(value: 1)
    private var popularPage = BehaviorRelay<Int>(value: 1)
    
    init(movieRepository: MovieRepository, navigator: MainNavigator) {
        self.movieRepository = movieRepository
        self.navigator = navigator
    }
    
    func transform(input: MainViewModel.Input) -> MainViewModel.Output {
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        let popularMoviesDriver = popularTotalMovies.asDriver()
        let upcommingMoviesDriver = upcommingTotalMovies.asDriver()
        let popularPageDriver = popularPage.asDriver()
        let upcommingPageDriver = upcommingPage.asDriver()

        let loadPopular = input.loaded
            .withLatestFrom(popularPageDriver)
            .flatMapLatest { page -> Driver<[Movie]> in
                return self.movieRepository.getPopularMovie(input: PopularMovieRequest(page: page))
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
            .do(onNext: { (movies) in
                self.popularTotalMovies.accept(movies)
            })
            .mapToVoid()
        
        let loadUpcomming = input.loaded
            .withLatestFrom(upcommingPageDriver)
            .flatMapLatest { page -> Driver<[Movie]> in
                return self.movieRepository.getUpcommingMovie(input: UpcommingMovieRequest(page: page))
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
            .do(onNext: { (movies) in
                self.upcommingTotalMovies.accept(movies)
            })
            .mapToVoid()

        let popularSelected = input.popularSelectTrigger
            .withLatestFrom(popularMoviesDriver) { indexPath, movies in
                return movies[indexPath.row]
            }
            .do(onNext: { movie in
                self.navigator.toDetailMovie(movie: movie)
            })
            .mapToVoid()
        
        let upcommingSelected = input.upcommingSelectTrigger
            .withLatestFrom(upcommingMoviesDriver) { indexPath, movies in
                return movies[indexPath.row]
            }
            .do(onNext: { movie in
                self.navigator.toDetailMovie(movie: movie)
            })
            .mapToVoid()
        
        let popularLoadMore = input.popularLoadMoreTrigger
            .throttle(1)
            .flatMapLatest { _ -> Driver<[Movie]> in
                self.popularPage.accept(self.popularPage.value + 1)
                return self.movieRepository.getPopularMovie(input: PopularMovieRequest(page: self.popularPage.value))
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriver(onErrorJustReturn: [])
            }
            .do(onNext: { movies in
                var current = self.popularTotalMovies.value
                current += movies
                self.popularTotalMovies.accept(current)
            })
            .mapToVoid()
            .asDriver(onErrorJustReturn: ())
        
        let upcommingLoadMore = input.upcommingLoadMoreTrigger
            .throttle(1)
            .flatMapLatest { _ -> Driver<[Movie]> in
                self.upcommingPage.accept(self.upcommingPage.value + 1)
                return self.movieRepository.getUpcommingMovie(input: UpcommingMovieRequest(page: self.upcommingPage.value))
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriver(onErrorJustReturn: [])
            }
            .do(onNext: { movies in
                var current = self.upcommingTotalMovies.value
                current += movies
                self.upcommingTotalMovies.accept(current)
            })
            .mapToVoid()
            .asDriver(onErrorJustReturn: ())
        
        let searchAction = input.searchButtonTrigger
            .do(onNext: { self.navigator.toSearch() })
            .mapToVoid()
        
        let homeExtensionAction = input.homeExtensionButtonTrigger
            .do(onNext: { self.navigator.toExtensionHome() })
            .mapToVoid()
        
        return Output(error: errorTracker.asDriver(),
                      popularMovies: popularMoviesDriver,
                      upcommingMovies: upcommingMoviesDriver,
                      indicator: activityIndicator.asDriver(),
                      searchAction: searchAction,
                      homeAction: homeExtensionAction,
                      popularLoadMore: popularLoadMore,
                      upcommingLoadMore: upcommingLoadMore,
                      upcommingLoaded: loadUpcomming,
                      popularLoaded: loadPopular,
                      popularSelected: popularSelected,
                      upcommingSelected: upcommingSelected)
    }
}

extension MainViewModel {
    struct Input {
        let popularLoadMoreTrigger: Driver<Void>
        let upcommingLoadMoreTrigger: Driver<Void>
        let popularSelectTrigger: Driver<IndexPath>
        let upcommingSelectTrigger: Driver<IndexPath>
        let searchButtonTrigger: Driver<Void>
        let homeExtensionButtonTrigger: Driver<Void>
        let loaded: Driver<Void>
    }
    
    struct Output {
        let error: Driver<Error>
        let popularMovies: Driver<[Movie]>
        let upcommingMovies: Driver<[Movie]>
        let indicator: Driver<Bool>
        let searchAction: Driver<Void>
        let homeAction: Driver<Void>
        let popularLoadMore: Driver<Void>
        let upcommingLoadMore: Driver<Void>
        let upcommingLoaded: Driver<Void>
        let popularLoaded: Driver<Void>
        let popularSelected: Driver<Void>
        let upcommingSelected: Driver<Void>
    }
}
