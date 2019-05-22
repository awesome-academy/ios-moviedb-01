//
//  Assembler.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/17/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

protocol Assembler: class,
    RepositoriesAssembler,
    GettingStartedAssembler,
    MovieDetailAssembler,
    MainAssembler,
    AppAssembler {
}

final class DefaultAssembler: Assembler {
}
