//
//  MovieDetailUseCase.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/17/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import RealmSwift

protocol MovieDetailUseCase {
    func getMovieDetail(movieId: Int) -> Observable<MovieDetail>
    func getCastList(movieId: Int) -> Observable<[Cast]>
    func getVideoList(movieId: Int) -> Observable<[Video]>
    func getObjects(fileName: String) -> Observable<Results<Movie>>
    func updateObject(fileName: String, updateFunc: @escaping () -> Void) -> Observable<Void>
    func saveObject(fileName: String, object: Movie) -> Observable<Void>
}

struct MovieDetailUseCaseImpl: MovieDetailUseCase {
    let repository: MovieRepository
    let realm: RealmRepository
    
    func getMovieDetail(movieId: Int) -> Observable<MovieDetail> {
        return repository.getMovieDetail(input: MovieDetailRequest(movieId: movieId))
    }
    
    func getCastList(movieId: Int) -> Observable<[Cast]> {
        return repository.getCastList(input: CastListRequest(movieId: movieId))
    }
    
    func getVideoList(movieId: Int) -> Observable<[Video]> {
        return repository.getVideoList(input: VideoListRequest(movieId: movieId))
    }
    
    func getObjects(fileName: String) -> Observable<Results<Movie>> {
        return realm.getObjects(fileName: fileName, objType: Movie.self)
    }
    
    func saveObject(fileName: String, object: Movie) -> Observable<Void> {
        return realm.saveObject(fileName: fileName, object: object)
    }
    
    func updateObject(fileName: String, updateFunc: @escaping () -> Void) -> Observable<Void> {
        return realm.updateObject(fileName: fileName, updateFunc: updateFunc)
    }
}
