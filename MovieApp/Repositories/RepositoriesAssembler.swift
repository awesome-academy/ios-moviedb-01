//
//  RepositoriesAssembler.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/17/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

protocol RepositoriesAssembler {
    func resolve() -> GenreReponsitory
    func resolve() -> MovieRepository
    func resolve() -> RealmRepository
}

extension RepositoriesAssembler where Self: DefaultAssembler {
    func resolve() -> GenreReponsitory {
        return GenreReponsitoryImpl()
    }
    
    func resolve() -> MovieRepository {
        return MovieRepositoryImpl()
    }
    
    func resolve() -> RealmRepository {
        return RealmRepositoryImpl()
    }
}
