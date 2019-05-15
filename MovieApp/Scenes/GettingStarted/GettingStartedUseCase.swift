//
//  GettingStartedUseCase.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/17/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

protocol GettingStartedUseCase {
    func getGenreList() -> Observable<[Genre]>
    func saveObjects(objects: [Genre]) -> Observable<Void>
}

struct GettingStartedUseCaseImpl: GettingStartedUseCase {
    let repository: GenreReponsitory
    let realm: RealmRepository
    
    func getGenreList() -> Observable<[Genre]> {
        return repository.getGenreList(input: GenreListRequest())
    }
    
    func saveObjects(objects: [Genre]) -> Observable<Void> {
        return realm.saveObjects(fileName: RealmConstansts.favoriteGenres, objects: objects)
    }
}
