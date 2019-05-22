//
//  MovieRepository.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/15/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

protocol MovieRepository {
    func getUpcommingMovie(input: UpcommingMovieRequest) -> Observable<[Movie]>
    func getPopularMovie(input: PopularMovieRequest) -> Observable<[Movie]>
    func getMovieDetail(input: MovieDetailRequest) -> Observable<MovieDetail>
    func getCastList(input: CastListRequest) -> Observable<[Cast]>
    func getVideoList(input: VideoListRequest) -> Observable<[Video]>
    func searchMovie(input: SearchMovieRequest) -> Observable<([Movie], Int)>
    func discoverMovie(input: DiscoverMovieRequest) -> Observable<([Movie], Int)>
}

final class MovieRepositoryImpl: MovieRepository {
    private var api = APIService.share
    
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
    
    func getMovieDetail(input: MovieDetailRequest) -> Observable<MovieDetail> {
        return api.request(input: input)
            .map({ (response: MovieDetail) -> MovieDetail in
                return response
            })
    }
    
    func getCastList(input: CastListRequest) -> Observable<[Cast]> {
        return api.request(input: input)
            .map({ (response: CastListResponse) -> [Cast] in
                return response.cast
            })
    }
    
    func getVideoList(input: VideoListRequest) -> Observable<[Video]> {
        return api.request(input: input)
            .map({ (response: VideoListResponse) -> [Video] in
                return response.videos
            })
    }
    
    func searchMovie(input: SearchMovieRequest) -> Observable<([Movie], Int)> {
        return api.request(input: input)
            .map({ (response: MovieResultResponse) -> ([Movie], Int) in
                return (response.movies, response.totalPages)
            })
    }
    
    func discoverMovie(input: DiscoverMovieRequest) -> Observable<([Movie], Int)> {
        return api.request(input: input)
            .map({ (response: MovieResultResponse) -> ([Movie], Int) in
                return (response.movies, response.totalPages)
            })
    }
}
