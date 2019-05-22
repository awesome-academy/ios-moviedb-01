//
//  SearchMovieViewModel.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/21/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

final class SearchMovieViewModel: ViewModelType {
    private let navigator: SearchMovieNavigator
    private let useCase: SearchMovieUseCase
    private var selectedGenres = BehaviorRelay<[Genre]>(value: [])
    private var searchQuery = BehaviorRelay<String>(value: "")
    private var movies = BehaviorRelay<[Movie]>(value: [])
    private var totalPages = PublishSubject<Int>()
    private var isSearching = BehaviorSubject<Bool>(value: false)
    
    init(navigator: SearchMovieNavigator, useCase: SearchMovieUseCase) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func transform(input: SearchMovieViewModel.Input) -> SearchMovieViewModel.Output {
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
        let search = input.searchTrigger
            .skip(1)
            .throttle(1.0)
            .distinctUntilChanged()
            .flatMapLatest { query -> Driver<([Movie], Int)> in
                if query.isEmpty { return Driver.just(([], 0)) }
                self.searchQuery.accept(query)
                self.isSearching.onNext(true)
                return self.useCase.searchMovie(query: query)
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
            .do(onNext: { (movies, totalPages) in
                self.movies.accept(movies)
                self.totalPages.onNext(totalPages > 999 ? 999 : totalPages)
            })
            .mapToVoid()
        let genreSelected = input.genreSelectTrigger
            .withLatestFrom(selectedGenres.asDriver()) { indexPath, genres -> IndexPath in
                self.isSearching.onNext(false)
                genres[indexPath.row].selected = !genres[indexPath.row].selected
                self.selectedGenres.accept(genres)
                return indexPath
            }
            .asDriver(onErrorJustReturn: IndexPath())
        let selectGenres = selectedGenres
            .asDriver()
            .skip(1)
            .throttle(1.0)
            .map { genres in
                return genres.filter { $0.selected }.map { $0.id }
            }
            .flatMapLatest { genreIdList -> Driver<([Movie], Int)> in
                if genreIdList.isEmpty { return Driver.just(([], 0)) }
                return self.useCase.discoverMovie(genreIdList: genreIdList)
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
            .do(onNext: { (movies, totalPages) in
                self.movies.accept(movies)
                self.totalPages.onNext(totalPages > 999 ? 999 : totalPages)
            })
            .mapToVoid()
        let paging = input.pageTrigger
            .withLatestFrom(isSearching.asDriver(onErrorJustReturn: false)) {
                return ($0, $1)
            }
            .flatMapLatest { (page, isSearching) -> Driver<([Movie], Int)> in
                if isSearching {
                    return self.useCase.searchMovie(query: self.searchQuery.value, page: page)
                        .trackActivity(activityIndicator)
                        .trackError(errorTracker)
                        .asDriverOnErrorJustComplete()
                } else {
                    return self.selectedGenres
                        .asDriver()
                        .map { genres in
                            return genres.filter { $0.selected }
                            .map { $0.id }
                        }
                        .flatMapLatest { genreIdList -> Driver<([Movie], Int)> in
                            if genreIdList.isEmpty { return Driver.just(([], 0)) }
                            return self.useCase.discoverMovie(genreIdList: genreIdList, page: page)
                                .trackActivity(activityIndicator)
                                .trackError(errorTracker)
                                .asDriverOnErrorJustComplete()
                        }
                }
            }
            .map { (movies, _) in
                self.movies.accept(movies)
            }
            .mapToVoid()
        let back = input.backTrigger
            .do(onNext: { _ in
                self.navigator.toBack()
            })
        let selectMovie = input.movieSelectTrigger
            .withLatestFrom(movies.asDriver()) {
                return ($1[$0.row], $0)
            }
            .map({ (movie, indexPath) -> IndexPath in
                self.navigator.toMovieDetail(movie: movie)
                return indexPath
            })
        
        return Output(genres: genres,
                      movies: movies.asDriver(),
                      genreSelected: genreSelected,
                      search: search,
                      selectGenres: selectGenres,
                      selectMovie: selectMovie,
                      seletedGenres: selectedGenres.asDriver(),
                      paging: paging,
                      totalPages: totalPages.asDriverOnErrorJustComplete(),
                      back: back,
                      error: errorTracker.asDriver(),
                      indicator: activityIndicator.asDriver())
    }
}

extension SearchMovieViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let pageTrigger: Driver<Int>
        let searchTrigger: Driver<String>
        let genreSelectTrigger: Driver<IndexPath>
        let movieSelectTrigger: Driver<IndexPath>
        let backTrigger: Driver<Void>
    }
    
    struct Output {
        let genres: Driver<[Genre]>
        let movies: Driver<[Movie]>
        let genreSelected: Driver<IndexPath>
        let search: Driver<Void>
        let selectGenres: Driver<Void>
        let selectMovie: Driver<IndexPath>
        let seletedGenres: Driver<[Genre]>
        let paging: Driver<Void>
        let totalPages: Driver<Int>
        let back: Driver<Void>
        let error: Driver<Error>
        let indicator: Driver<Bool>
    }
}
