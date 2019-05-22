//
//  AppNavigator.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/17/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

protocol AppNavigator {
    func toGettingStarted()
    func toMain()
}

struct AppNavigatorImpl: AppNavigator {
    unowned let assembler: Assembler
    unowned let window: UIWindow
    
    func toGettingStarted() {
        let nav = UINavigationController()
        let vc: GettingStartedViewController = assembler.resolve()
        nav.pushViewController(vc, animated: true)
        window.rootViewController = nav
    }
    
    func toMain() {
        let nav = UINavigationController()
        let vc: MainViewController = assembler.resolve(navigationController: nav)
        nav.pushViewController(vc, animated: true)
        window.rootViewController = nav
    }
}
