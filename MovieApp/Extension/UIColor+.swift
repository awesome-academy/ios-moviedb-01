//
//  UIColor+.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/14/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    static let gradientGettingStartedBackground = [UIColor(rgb: 0x6C6C6C).cgColor, UIColor(rgb: 0x000000).cgColor]
    static let gettingStartedButton = UIColor(rgb: 0x49525D)
}
