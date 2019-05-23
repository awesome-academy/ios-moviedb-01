//
//  MainUseCase.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/19/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

protocol MainUseCase {
    func getUpcommingMovie(page: Int) -> Observable<[Movie]>
    func getPopularMovie(page: Int) -> Observable<[Movie]>
}

struct MainUseCaseImpl: MainUseCase {
    let repository: MovieRepository
    
    func getUpcommingMovie(page: Int) -> Observable<[Movie]> {
        return repository.getUpcommingMovie(input: UpcommingMovieRequest(page: page))
    }
    
    func getPopularMovie(page: Int) -> Observable<[Movie]> {
        return repository.getPopularMovie(input: PopularMovieRequest(page: page))
    }
}
