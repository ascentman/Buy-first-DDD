//
//  MainViewController.swift
//  Buy first DDD
//
//  Created by user on 6/20/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

enum Condition: Int, CaseIterable {
    case any = 0
    case new
    case openBox
    case manufactureRefurbished
    case sellerRefurbished
    case used
    case forParts

    var value: String {
        switch self {
        case .any:
            return "any"
        case .new:
            return "new"
        case .openBox:
            return "open box"
        case .manufactureRefurbished:
            return "manufacture refurbished"
        case .sellerRefurbished:
            return "seller refurbished"
        case .used:
            return "used"
        case .forParts:
            return "for parts"
        }
    }
}

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

struct Checkmark {
    let isChecked: Bool
    let onSelect: () -> Void
}

final class MainTableViewController: UITableViewController {

    var props: Props = .initial

    struct Props {
        let title: String
        var auctionCheckMark: Checkmark
        let buyItNowCheckMark: Checkmark
        let anyShippingCheckmark: Checkmark
        let freeShippingCheckmark: Checkmark

        var selectedCondition: Condition
        let onUpdateCondition: (Condition) -> Void

        static let initial = Props(title: "",
                                   auctionCheckMark: Checkmark(isChecked: false, onSelect: {}),
                                   buyItNowCheckMark: Checkmark(isChecked: false, onSelect: {}),
                                   anyShippingCheckmark: Checkmark(isChecked: false, onSelect: {}),
                                   freeShippingCheckmark: Checkmark(isChecked: false, onSelect: {}),
                                   selectedCondition: .any,
                                   onUpdateCondition: { _ in })
    }

    func render(props: Props) {
        self.props = props
        title = props.title
        if self.isViewLoaded {
            markRow(cell: auctionCell, state: props.auctionCheckMark.isChecked)
            markRow(cell: buyItNowCell, state: props.buyItNowCheckMark.isChecked)
            markRow(cell: anyShippingCell, state: props.anyShippingCheckmark.isChecked)
            markRow(cell: freeShippingCell, state: props.freeShippingCheckmark.isChecked)

            tableView.reloadData()
        }
    }

    @IBOutlet weak var auctionCell: UITableViewCell!
    @IBOutlet weak var buyItNowCell: UITableViewCell!
    @IBOutlet weak var conditionCell: UITableViewCell!
    @IBOutlet weak var conditionPicker: UIPickerView!
    @IBOutlet weak var anyShippingCell: UITableViewCell!
    @IBOutlet weak var freeShippingCell: UITableViewCell!

    private var conditionPickerIsHidden = false

    override func viewDidLoad() {
        super.viewDidLoad()

        render(props: props)
        tableView.tableFooterView = UIView()
        togglePicker()
        conditionPicker.delegate = self
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = Row(indexPath: indexPath)
        switch row {
        case .condition:
            togglePicker()
        case .auction:
            props.auctionCheckMark.onSelect()
        case .buyItNow:
            props.buyItNowCheckMark.onSelect()
        case .anyShipping:
            props.anyShippingCheckmark.onSelect()
        case .freeShipping:
            props.freeShippingCheckmark.onSelect()
        default:
            break
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = Row(indexPath: indexPath)
        return conditionPickerIsHidden && row == .conditionPicker ? 0 : super.tableView(tableView, heightForRowAt: indexPath)
    }

    // MARK: - Private

    private func togglePicker() {
        conditionPickerIsHidden = !conditionPickerIsHidden
        tableView.reloadData()
    }

    private func markRow(cell: UITableViewCell, state: Bool) {
        if state {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
}

// MARK: - UIPickerViewDataSource & UIPickerViewDelegate

extension MainTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Condition.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Condition(rawValue: row)?.value
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let condition = Condition(rawValue: row) {
            conditionCell.detailTextLabel?.text = condition.value
            props.onUpdateCondition(condition)
        }
    }
}
