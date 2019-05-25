//
//  UISearchBar+.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/24/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

extension UISearchBar {
    public func setSerchTextcolor(color: UIColor) {
        let clrChange = subviews.flatMap { $0.subviews }
        guard let sc = (clrChange.first { $0 is UITextField }) as? UITextField else { return }
        sc.textColor = color
    }
}
