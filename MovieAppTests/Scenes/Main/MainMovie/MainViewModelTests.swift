//
//  MainViewModelTests.swift
//  MovieAppTests
//
//  Created by nguyen.nam.khanh on 5/23/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import MovieApp

final class MainViewModelTests: XCTestCase {
    private var viewModel: MainViewModel!
    private var navigator: MainNavigatorMock!
    private var useCase: MainUseCaseMock!
    
    private var input: MainViewModel.Input!
    private var output: MainViewModel.Output!
    
    private var disposeBag: DisposeBag!
    
    private let popularLoadMoreTrigger = PublishSubject<Void>()
    private let upcommingLoadMoreTrigger = PublishSubject<Void>()
    private let popularSelectTrigger = PublishSubject<IndexPath>()
    private let upcommingSelectTrigger = PublishSubject<IndexPath>()
    private let homeExtensionButtonTrigger = PublishSubject<Void>()
    private let searchButtonTrigger = PublishSubject<Void>()
    private let loaded = PublishSubject<Void>()
    
    override func setUp() {
        super.setUp()
        navigator = MainNavigatorMock()
        useCase = MainUseCaseMock()
        disposeBag = DisposeBag()
        viewModel = MainViewModel(navigator: navigator, useCase: useCase)
        
        input = MainViewModel.Input(popularLoadMoreTrigger: popularLoadMoreTrigger.asDriverOnErrorJustComplete(),
                                    upcommingLoadMoreTrigger: upcommingLoadMoreTrigger.asDriverOnErrorJustComplete(),
                                    popularSelectTrigger: popularSelectTrigger.asDriverOnErrorJustComplete(),
                                    upcommingSelectTrigger: upcommingSelectTrigger.asDriverOnErrorJustComplete(),
                                    searchButtonTrigger: searchButtonTrigger.asDriverOnErrorJustComplete(),
                                    homeExtensionButtonTrigger: homeExtensionButtonTrigger.asDriverOnErrorJustComplete(),
                                    loaded: loaded.asDriverOnErrorJustComplete())
        output = viewModel.transform(input: input)
        
        output.error.drive().disposed(by: disposeBag)
        output.popularMovies.drive().disposed(by: disposeBag)
        output.upcommingMovies.drive().disposed(by: disposeBag)
        output.indicator.drive().disposed(by: disposeBag)
        output.searchAction.drive().disposed(by: disposeBag)
        output.homeAction.drive().disposed(by: disposeBag)
        output.popularLoadMore.drive().disposed(by: disposeBag)
        output.upcommingLoadMore.drive().disposed(by: disposeBag)
        output.upcommingLoaded.drive().disposed(by: disposeBag)
        output.popularLoaded.drive().disposed(by: disposeBag)
        output.popularSelected.drive().disposed(by: disposeBag)
        output.upcommingSelected.drive().disposed(by: disposeBag)
    }
    
    func test_loadedTriggerInvoked() {
        loaded.onNext(())
        let popular = try? output.popularMovies.toBlocking(timeout: 1).first()
        let upcomming = try? output.upcommingMovies.toBlocking(timeout: 1).first()
        XCTAssertEqual(popular??.count, 1)
        XCTAssertEqual(upcomming??.count, 1)
    }
    
    func test_popularLoadMoreTriggerInvoked() {
        popularLoadMoreTrigger.onNext(())
        let popular = try? output.popularMovies.toBlocking(timeout: 1).first()
        XCTAssertEqual(popular??.count, 1)
    }
    
    func test_upcommingLoadMoreTriggerInvoked() {
        upcommingLoadMoreTrigger.onNext(())
        let upcomming = try? output.upcommingMovies.toBlocking(timeout: 1).first()
        XCTAssertEqual(upcomming??.count, 1)
    }
    
    func test_popularLoadMoreTriggerInvoked_failedShowError() {
        let getPopularMovieReturnValue = PublishSubject<[Movie]>()
        useCase.getPopularMovieReturnValue = getPopularMovieReturnValue
        
        popularLoadMoreTrigger.onNext(())
        getPopularMovieReturnValue.onError(TestError())
        
        let error = try? output.error.toBlocking(timeout: 1).first()
        
        XCTAssert(useCase.getPopularMovieListCalled)
        XCTAssert(error is TestError)
    }
    
    func test_upcommingLoadMoreTriggerInvoked_failedShowError() {
        let getUpcommingMovieReturnValue = PublishSubject<[Movie]>()
        useCase.getUpcommingMovieReturnValue = getUpcommingMovieReturnValue
        
        upcommingLoadMoreTrigger.onNext(())
        getUpcommingMovieReturnValue.onError(TestError())
        
        let error = try? output.error.toBlocking(timeout: 1).first()
        
        XCTAssert(useCase.getUpcommingMovieListCalled)
        XCTAssert(error is TestError)
    }
    
    func test_selectPopularMoviesInvoked_toDetail() {
        loaded.onNext(())
        popularSelectTrigger.onNext(IndexPath(item: 0, section: 0))
        XCTAssert(navigator.toDetailMovieCalled)
    }
    
    func test_selectUpcommingMoviesInvoked_toDetail() {
        loaded.onNext(())
        upcommingSelectTrigger.onNext(IndexPath(item: 0, section: 0))
        XCTAssert(navigator.toDetailMovieCalled)
    }
    
    func test_goToHomeExtensionInvoked() {
        homeExtensionButtonTrigger.onNext(())
        XCTAssert(navigator.toHomeExtensionCalled)
    }
    
    func test_goToSearchInvoked() {
        searchButtonTrigger.onNext(())
        XCTAssert(navigator.toSearchCalled)
    }
}
