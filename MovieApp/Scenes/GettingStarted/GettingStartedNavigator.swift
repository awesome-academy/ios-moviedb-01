//
//  GettingStartedNavigator.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/13/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit

protocol GettingStartedNavigator {
    func toMain()
}

final class DefaultGettingStartedNavigator: GettingStartedNavigator {
    private unowned let viewController: UIViewController
    private unowned let assembler: Assembler
    
    init(assembler: Assembler, viewController: UIViewController) {
        self.viewController = viewController
        self.assembler = assembler
    }
    
    func toMain() {
        let nav = UINavigationController()
        let vc: MainViewController = assembler.resolve(navigationController: nav)
        nav.pushViewController(vc, animated: true)
        viewController.present(nav, animated: false, completion: nil)
    }
}
