//
//  MainViewController.swift
//  Buy first DDD
//
//  Created by user on 6/20/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

private enum Row: Int {
    case title
    case auction
    case buyItNow
    case condition
    case conditionPicker
    case anyShipping
    case freeShipping
    case unknown

    init(indexPath: IndexPath) {
        var row = Row.unknown

        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            row = Row.title
        case (1, 0):
            row = Row.auction
        case (1, 1):
            row = Row.buyItNow
        case (2, 0):
            row = Row.condition
        case (2, 1):
            row = Row.conditionPicker
        case (3, 0):
            row = Row.anyShipping
        case (3, 1):
            row = Row.freeShipping
        default:
            break
        }

        self = row
    }
}

final class MainTableViewController: UITableViewController {

    @IBOutlet weak var auctionCell: UITableViewCell!
    @IBOutlet weak var buyItNowCell: UITableViewCell!
    @IBOutlet weak var conditionCell: UITableViewCell!
    @IBOutlet weak var conditionPicker: UIPickerView!
    @IBOutlet weak var anyShippingCell: UITableViewCell!
    @IBOutlet weak var freeShippingCell: UITableViewCell!

    private var conditionPickerIsHidden = false
    private var conditions: [String] = [
        "any",
        "new",
        "open box",
        "manufacture refurbished",
        "seller refurbished",
        "used",
        "for parts"
    ]
    private var selectedCondition: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search"
        tableView.tableFooterView = UIView()
        toggleDatePicker()
        conditionPicker.delegate = self
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = Row(indexPath: indexPath)
        switch row {
        case .condition:
            toggleDatePicker()
        case .auction:
            changeCellAccessoryType(cell: auctionCell)
        case .buyItNow:
            changeCellAccessoryType(cell: buyItNowCell)
        case .anyShipping:
            changeCellAccessoryType(cell: anyShippingCell)
        case .freeShipping:
            changeCellAccessoryType(cell: freeShippingCell)
        default:
            break
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = Row(indexPath: indexPath)
        return conditionPickerIsHidden && row == .conditionPicker ? 0 : super.tableView(tableView, heightForRowAt: indexPath)
    }

    // MARK: - Private

    private func toggleDatePicker() {
        conditionPickerIsHidden = !conditionPickerIsHidden
        tableView.reloadData()
    }

    private func changeCellAccessoryType(cell: UITableViewCell) {
        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .checkmark
        }
    }
}

// MARK: - UIPickerViewDataSource & UIPickerViewDelegate

extension MainTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return conditions.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return conditions[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCondition = conditions[row]
        conditionCell.detailTextLabel?.text = selectedCondition
    }
}
