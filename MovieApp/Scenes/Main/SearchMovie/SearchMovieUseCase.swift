//
//  SearchMovieUseCase.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/21/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

protocol SearchMovieUseCase {
    func getGenreList() -> Observable<[Genre]>
    func searchMovie(query: String, page: Int) -> Observable<([Movie], Int)>
    func searchMovie(query: String) -> Observable<([Movie], Int)>
    func discoverMovie(genreIdList: [Int], page: Int) -> Observable<([Movie], Int)>
    func discoverMovie(genreIdList: [Int]) -> Observable<([Movie], Int)>
}

struct SearchMovieUseCaseImpl: SearchMovieUseCase {
    let movieRepository: MovieRepository
    let genreRepository: GenreReponsitory
    
    func searchMovie(query: String, page: Int) -> Observable<([Movie], Int)> {
        return movieRepository.searchMovie(input: SearchMovieRequest(query: query, page: page))
    }
    
    func searchMovie(query: String) -> Observable<([Movie], Int)> {
        return movieRepository.searchMovie(input: SearchMovieRequest(query: query, page: 1))
    }
    
    func discoverMovie(genreIdList: [Int], page: Int) -> Observable<([Movie], Int)> {
        return movieRepository.discoverMovie(input: DiscoverMovieRequest(genreIdList: genreIdList, page: page))
    }
    
    func discoverMovie(genreIdList: [Int]) -> Observable<([Movie], Int)> {
        return movieRepository.discoverMovie(input: DiscoverMovieRequest(genreIdList: genreIdList, page: 1))
    }
    
    func getGenreList() -> Observable<[Genre]> {
        return genreRepository.getGenreList(input: GenreListRequest())
    }
}
