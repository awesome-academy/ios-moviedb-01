//
//  MovieDetailViewModelTests.swift
//  MovieAppTests
//
//  Created by Phan Dinh Van on 5/16/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

@testable import MovieApp
import XCTest
import RxSwift
import RxBlocking

final class MovieDetailViewModelTests: XCTestCase {
    private var viewModel: MovieDetailViewModel!
    private var navigator: MovieDetailNavigatorMock!
    private var useCase: MovieDetailUseCaseMock!
    
    private var input: MovieDetailViewModel.Input!
    private var output: MovieDetailViewModel.Output!
    
    private var disposeBag: DisposeBag!
    
    private let loadTrigger = PublishSubject<Void>()
    private let actorSelectTrigger = PublishSubject<IndexPath>()
    private let likeTrigger = PublishSubject<Void>()
    private let backTrigger = PublishSubject<Void>()
    
    override func setUp() {
        super.setUp()
        let movie = Movie().with { $0.id = 1 }
        navigator = MovieDetailNavigatorMock()
        useCase = MovieDetailUseCaseMock()
        viewModel = MovieDetailViewModel(navigator: navigator, useCase: useCase, movie: movie)
        
        input = MovieDetailViewModel.Input(
            loadTrigger: loadTrigger.asDriverOnErrorJustComplete(),
            actorSelectTrigger: actorSelectTrigger.asDriverOnErrorJustComplete(),
            likeTrigger: likeTrigger.asDriverOnErrorJustComplete(),
            backTrigger: backTrigger.asDriverOnErrorJustComplete()
        )
        output = viewModel.transform(input: input)
        print(output)
        
        disposeBag = DisposeBag()

        output.actorSelected.drive().disposed(by: disposeBag)
        output.backTapped.drive().disposed(by: disposeBag)
        output.cast.drive().disposed(by: disposeBag)
        output.error.drive().disposed(by: disposeBag)
        output.indicator.drive().disposed(by: disposeBag)
        output.liked.drive().disposed(by: disposeBag)
        output.likeTapped.drive().disposed(by: disposeBag)
        output.movieOverview.drive().disposed(by: disposeBag)
        output.titleMovie.drive().disposed(by: disposeBag)
        output.voteAverage.drive().disposed(by: disposeBag)
        output.backgroundImage.drive().disposed(by: disposeBag)
        output.trailer.drive().disposed(by: disposeBag)
    }
    
    func test_loadTriggerInvoked_getMovieDetail_getCastList_getVideoList() {
        loadTrigger.onNext(())
        let titleMovie = try? output.titleMovie.toBlocking(timeout: 1).first()
        let movieOverview = try? output.movieOverview.toBlocking(timeout: 1).first()
        let voteAverage = try? output.voteAverage.toBlocking(timeout: 1).first()
        let backgroundImage = try? output.backgroundImage.toBlocking(timeout: 1).first()
        let cast = try? output.cast.toBlocking(timeout: 1).first()
        let trailer = try? output.trailer.toBlocking(timeout: 1).first()
        XCTAssert(useCase.getVideoListCalled)
        XCTAssert(useCase.getMovieDetailCalled)
        XCTAssert(useCase.getCastListCalled)
        XCTAssertEqual(cast??.count, 1)
        XCTAssertEqual(trailer??.count, 1)
        XCTAssertNotNil(titleMovie as Any)
        XCTAssertNotNil(movieOverview as Any)
        XCTAssertNotNil(voteAverage as Any)
        XCTAssertNotNil(backgroundImage as Any)
    }
    
    func test_loadTriggerInvoked_getMovieDetail_failedShowError() {
        let getMovieDetailReturnValue = PublishSubject<MovieDetail>()
        useCase.getMovieDetailReturnValue = getMovieDetailReturnValue
        
        loadTrigger.onNext(())
        getMovieDetailReturnValue.onError(TestError())
        let error = try? output.error.toBlocking(timeout: 1).first()
    
        XCTAssert(useCase.getMovieDetailCalled)
        XCTAssert(error is TestError)
    }
    
    func test_loadTriggerInvoked_getCastList_failedShowError() {
        let getCastListReturnValue = PublishSubject<[Cast]>()
        useCase.getCastListReturnValue = getCastListReturnValue
        
        loadTrigger.onNext(())
        getCastListReturnValue.onError(TestError())
        let error = try? output.error.toBlocking(timeout: 1).first()
        
        XCTAssert(useCase.getCastListCalled)
        XCTAssert(error is TestError)
    }
    
    func test_loadTriggerInvoked_getVideoList_failedShowError() {
        let getVideoListReturnValue = PublishSubject<[Video]>()
        useCase.getVideoListReturnValue = getVideoListReturnValue
        
        loadTrigger.onNext(())
        getVideoListReturnValue.onError(TestError())
        let error = try? output.error.toBlocking(timeout: 1).first()
        
        XCTAssert(useCase.getVideoListCalled)
        XCTAssert(error is TestError)
    }
    
    func test_actorSelectTriggerInvoked_toActor() {
        loadTrigger.onNext(())
        actorSelectTrigger.onNext(IndexPath(row: 0, section: 0))
        XCTAssert(navigator.isToActorCalled)
    }
    
    func test_backTriggerInvoked_back() {
        backTrigger.onNext(())
        XCTAssert(navigator.isBackCalled)
    }
    
    func test_likeTriggerInvoked_getObjects_saveObject() {
        likeTrigger.onNext(())
        XCTAssert(useCase.getObjectsCalled)
        XCTAssert(useCase.saveObjectCalled)
    }
    
    func test_likeTriggerInvoked_getObjects_updateObject() {
        let movies = try? useCase
            .getObjects(fileName: RealmConstansts.likedMovies)
            .toBlocking(timeout: 1)
            .first()
        if let movies = movies, let movie = movies?.first {
            viewModel.movie = movie
        }
        likeTrigger.onNext(())
        XCTAssert(useCase.getObjectsCalled)
        XCTAssert(useCase.updateObjectCalled)
    }
}
