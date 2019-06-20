//
//  MainViewControllerInteractor.swift
//  Buy first DDD
//
//  Created by user on 6/20/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation

final class MainViewControllerInteractor {

    private let presenter: MainViewControllerPresenter

    init(presenter: MainViewControllerPresenter) {
        self.presenter = presenter
    }
}
