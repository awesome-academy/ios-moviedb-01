//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/15/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import RealmSwift

final class MovieDetailViewModel: ViewModelType {
    private let useCase: MovieDetailUseCase
    private let navigator: MovieDetailNavigator
    var movie: Movie!
    
    init(navigator: MovieDetailNavigator, useCase: MovieDetailUseCase, movie: Movie) {
        self.navigator = navigator
        self.useCase = useCase
        self.movie = movie
    }
    
    func transform(input: MovieDetailViewModel.Input) -> MovieDetailViewModel.Output {
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        let movieDetail = input.loadTrigger
            .flatMapLatest { _ in
                return self.useCase.getMovieDetail(movieId: self.movie.id)
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
        
        let titleMovie = movieDetail.map { $0.title }
        
        let voteAverage = movieDetail.map { "\($0.voteAverage)/10" }
        
        let movieOverview = movieDetail.map { $0.overview }
        
        let backgroundImage = movieDetail.map { URL(string: URLs.posterApi + $0.posterPath ) }
        
        let cast = input.loadTrigger
            .flatMapLatest { _ in
                return self.useCase.getCastList(movieId: self.movie.id)
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
        
        let trailer = input.loadTrigger
            .flatMapLatest { _ in
                return self.useCase.getVideoList(movieId: self.movie.id)
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
        
        let liked = input.loadTrigger
            .flatMapLatest {
                return self.useCase.getObjects(fileName: RealmConstansts.likedMovies)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
            .map { movies -> Bool in
                let likedMovie = movies.first { $0.id == self.movie.id }
                if let likedMovie = likedMovie {
                    return likedMovie.liked
                } else {
                    return false
                }
            }
        
        let likeTapped = input.likeTrigger
            .flatMapLatest {
                return self.useCase.getObjects(fileName: RealmConstansts.likedMovies)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
            .flatMapLatest { movies -> Driver<Void> in
                let likedMovie = movies.first { $0.id == self.movie.id }
                if let likedMovie = likedMovie {
                    return self.useCase.updateObject(fileName: RealmConstansts.likedMovies) {
                       likedMovie.liked = !likedMovie.liked
                    }
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
                } else {
                    self.movie.liked = true
                    return self.useCase.saveObject(fileName: RealmConstansts.likedMovies, object: self.movie)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
                }
            }
        
        let actorSelected = input.actorSelectTrigger
            .withLatestFrom(cast) { indexPath, cast in
                return cast[indexPath.row]
            }
            .do(onNext: { (cast) in
                self.navigator.toActor(cast: cast)
            })
            .mapToVoid()
        
        let backTapped = input.backTrigger
            .do(onNext: { _ in
                self.navigator.back()
            })
            .mapToVoid()
        
        let constraintUpdate = Observable.of(titleMovie.mapToVoid().asObservable(),
                                              movieOverview.mapToVoid().asObservable())
            .merge()
            .asDriverOnErrorJustComplete()
    
        return Output(
            titleMovie: titleMovie,
            voteAverage: voteAverage,
            movieOverview: movieOverview,
            backgroundImage: backgroundImage,
            cast: cast,
            trailer: trailer,
            actorSelected: actorSelected,
            likeTapped: likeTapped,
            liked: liked,
            backTapped: backTapped,
            constraintUpdate: constraintUpdate,
            error: errorTracker.asDriver(),
            indicator: activityIndicator.asDriver())
    }
}

extension MovieDetailViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let actorSelectTrigger: Driver<IndexPath>
        let likeTrigger: Driver<Void>
        let backTrigger: Driver<Void>
    }
    
    struct Output {
        let titleMovie: Driver<String>
        let voteAverage: Driver<String>
        let movieOverview: Driver<String>
        let backgroundImage: Driver<URL?>
        let cast: Driver<[Cast]>
        let trailer: Driver<[Video]>
        let actorSelected: Driver<Void>
        let likeTapped: Driver<Void>
        let liked: Driver<Bool>
        let backTapped: Driver<Void>
        let constraintUpdate: Driver<Void>
        let error: Driver<Error>
        let indicator: Driver<Bool>
    }
}
