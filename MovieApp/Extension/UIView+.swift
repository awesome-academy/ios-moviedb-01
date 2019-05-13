//
//  UIView+.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/13/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit

extension UIView {
    func setBorder(borderWidth: CGFloat, borderColor: UIColor, cornerRadius: CGFloat) {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
}
