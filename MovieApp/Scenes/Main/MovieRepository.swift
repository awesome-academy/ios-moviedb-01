//
//  MovieRepository.swift
//  MovieApp
//
//  Created by nguyen.nam.khanh on 5/16/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

protocol MovieRepository {
    func getUpcommingMovie(input: UpcommingMovieRequest) -> Observable<[Movie]>
    func getPopularMovie(input: PopularMovieRequest) -> Observable<[Movie]>
    func findMovie(input: FindMovieRequest) -> Observable<Movie>
}

class MovieRepositoryImpl: MovieRepository {
    private var api: APIService!
    
    required init(api: APIService) {
        self.api = api
    }
    
    func getUpcommingMovie(input: UpcommingMovieRequest) -> Observable<[Movie]> {
        return api.request(input: input)
            .map({ (response: UpcommingMovieResponse) -> [Movie] in
                return response.movies
            })
    }
    
    func getPopularMovie(input: PopularMovieRequest) -> Observable<[Movie]> {
        return api.request(input: input)
            .map({ (response: PopularMovieResponse) -> [Movie] in
                return response.movies
            })
    }
    
    func findMovie(input: FindMovieRequest) -> Observable<Movie> {
        return api.request(input: input)
            .map({ (response: FindMovieResponse) -> Movie in
                guard let response = response.movie else { return Movie() }
                return response
            })
    }
}
