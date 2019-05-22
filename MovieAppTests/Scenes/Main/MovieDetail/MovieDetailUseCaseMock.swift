//
//  MovieDetailUseCaseMock.swift
//  MovieAppTests
//
//  Created by Phan Dinh Van on 5/16/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

@testable import MovieApp
import RxSwift
import RealmSwift

final class MovieDetailUseCaseMock: MovieDetailUseCase {
    let realm = RealmRepositoryImpl()
    
    var getObjectsCalled = false
    
    func getObjects(fileName: String) -> Observable<Results<Movie>> {
        getObjectsCalled = true
        return realm.getObjects(fileName: RealmConstansts.likedMovies, objType: Movie.self)
    }
    
    var updateObjectCalled = false
    
    func updateObject(fileName: String, updateFunc: @escaping () -> Void) -> Observable<Void> {
        updateObjectCalled = true
        return Observable.just(())
    }
    
    var saveObjectCalled = false
    
    func saveObject(fileName: String, object: Movie) -> Observable<Void> {
        saveObjectCalled = true
        return Observable.just(())
    }
    
    var getMovieDetailCalled = false
    
    var getMovieDetailReturnValue: Observable<MovieDetail> = {
        let item = MovieDetail().with { $0.id = 1 }
        return Observable.just(item)
    }()
    
    func getMovieDetail(movieId: Int) -> Observable<MovieDetail> {
        getMovieDetailCalled = true
        return getMovieDetailReturnValue
    }
    
    var getCastListCalled = false
    
    var getCastListReturnValue: Observable<[Cast]> = {
        let items = [ Cast().with { $0.personId = 1 } ]
        return Observable.just(items)
    }()
    
    func getCastList(movieId: Int) -> Observable<[Cast]> {
        getCastListCalled = true
        return getCastListReturnValue
    }
    
    var getVideoListCalled = false
    
    var getVideoListReturnValue: Observable<[Video]> = {
        let items = [Video()]
        return Observable.just(items)
    }()
    
    func getVideoList(movieId: Int) -> Observable<[Video]> {
        getVideoListCalled = true
        return getVideoListReturnValue
    }
}
