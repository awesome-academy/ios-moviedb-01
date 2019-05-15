//
//  AppSettings.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/17/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

final class AppSettings: NSObject {
    class var didInit: Bool {
        get {
            return UserDefaults.standard.bool(forKey: #function)
        }
        set {
            UserDefaults.standard.do {
                $0.set(newValue, forKey: #function)
                $0.synchronize()
            }
        }
    }
}
