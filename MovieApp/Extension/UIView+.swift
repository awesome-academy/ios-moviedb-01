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
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = UIView().then {
            $0.backgroundColor = color
        }
        addSubview(border)
        border.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            $0.heightAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
}
