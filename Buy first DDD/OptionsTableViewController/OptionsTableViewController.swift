//
//  OptionsTableViewController.swift
//  Buy first DDD
//
//  Created by user on 7/7/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

final class OptionsTableViewController: UITableViewController {

    @IBOutlet private weak var itemsStepper: UIStepper!
    @IBOutlet private weak var itemsLabel: UILabel!
    @IBOutlet private weak var reloadStepper: UIStepper!
    @IBOutlet private weak var reloadTimeLabel: UILabel!
    @IBOutlet private weak var reloadSwitch: UISwitch!
    @IBOutlet private weak var availableSearches: UILabel!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSettings()
        setupSteppers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.title = "Settings"
        availableSearches.text = String(UserDefaults.standard.searchesCount)
        let animation = AnimationFactory.makeSlideIn(duration: 0.3, delayFactor: 0.05)
        let animator = Animator(animation: animation)
        animator.animate(tableView: tableView)
    }

    // MARK: - Actions

    @IBAction func itemsCountDidPressed(_ sender: UIStepper) {
        itemsLabel.text = Int(sender.value).description
        UserDefaults.standard.updateItemsCount(Int(sender.value))
    }

    @IBAction func timeIntervalDidPressed(_ sender: UIStepper) {
        reloadTimeLabel.text = Int(sender.value).description
        UserDefaults.standard.updateReloadTimeInterval(Int(sender.value))
    }

    @IBAction func reloadOnStartDidPressed(_ sender: UISwitch) {
        UserDefaults.standard.updateContinuousReload(sender.isOn)
    }

    // MARK: - Private

    private func setupSteppers() {
        itemsStepper.wraps = true
        itemsStepper.stepValue = 3
        itemsStepper.minimumValue = 1
        itemsStepper.maximumValue = 10

        reloadStepper.wraps = true
        reloadStepper.stepValue = 10
        reloadStepper.minimumValue = 10
        reloadStepper.maximumValue = 600
    }

    private func setupSettings() {
        reloadTimeLabel.text = String(UserDefaults.standard.reloadTimeInterval)
        itemsLabel.text = String(UserDefaults.standard.itemsCount)
        reloadSwitch.isOn = UserDefaults.standard.continuousReload
    }
}
