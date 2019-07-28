//
//  AboutTableViewController.swift
//  Buy first DDD
//
//  Created by user on 7/23/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

final class AboutTableViewController: UITableViewController {

    @IBOutlet private weak var seaches30Button: UIButton!
    @IBOutlet private weak var searches100Button: UIButton!
    @IBOutlet private weak var remvoeAdsButton: UIButton!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.title = "About"
    }

    // MARK: - Actions

    @IBAction func searches30DidPressed(_ sender: Any) {
    }
    @IBAction func searches100DidPressed(_ sender: Any) {
    }

    @IBAction func removeAdsDidPressed(_ sender: Any) {
    }
    @IBAction func restorePurchasesDidPressed(_ sender: Any) {
    }
}
