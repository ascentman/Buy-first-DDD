//
//  StartTableViewControllerPresenter.swift
//  Buy first DDD
//
//  Created by user on 6/27/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation

final class StartViewControllerPresenter {

    let startViewController: StartViewController?
    var onSearchPressed: (String) -> Void = { _ in assertionFailure() }

    init(viewController: StartViewController) {
        self.startViewController = viewController
    }

    func present(title: String, name: String) {

        startViewController?.render(props: StartViewController.Props(title: title,
                                                                          itemName: name,
                                                                          onSearch: onSearchPressed
        ))
    }
}
