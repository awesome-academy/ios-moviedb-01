//
//  GettingStartedNavigator.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/13/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import RealmSwift

protocol GettingStartedNavigator {
    func toMain()
}

final class DefaultGettingStartedNavigator: GettingStartedNavigator {
    private let viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func toMain() {
        let vc = Storyboards.main.instantiateInitialViewController()
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            window.rootViewController = vc            
        }
    }
}
