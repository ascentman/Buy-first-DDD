//
//  AboutTableViewController.swift
//  Buy first DDD
//
//  Created by user on 7/23/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

final class AboutTableViewController: UITableViewController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.title = "About"
    }
}
