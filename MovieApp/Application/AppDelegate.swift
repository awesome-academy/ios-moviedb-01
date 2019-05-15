//
//  AppDelegate.swift
//  MovieApp
//
//  Created by nguyen.nam.khanh on 5/10/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var assembler: Assembler = DefaultAssembler()

    func applicationDidFinishLaunching(_ application: UIApplication) {
        bindViewModel()
    }
    
    private func bindViewModel() {
        guard let window = window else { return }
        let vm: AppViewModel = assembler.resolve(window: window)
        let input = AppViewModel.Input(loadTrigger: Driver.just(()))
        let output = vm.transform(input: input)
        output.toScreen
            .drive()
            .dispose()
    }
}

