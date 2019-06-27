//
//  StartTableViewControllerInteractor.swift
//  Buy first DDD
//
//  Created by user on 6/27/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation

final class StartTableViewControllerInteractor {

    private let presenter: StartTableViewControllerPresenter
    private let viewControllerTitle = "Start"

    init(presenter: StartTableViewControllerPresenter, onSearchRequested: @escaping (String) -> ()) {
        self.presenter = presenter

        presenter.onSearchPressed = { name in
            onSearchRequested(name)
        }
    }

    func start() {
        presenter.present(title: viewControllerTitle, name: "")
    }
}
