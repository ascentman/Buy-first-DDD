//
//  StartTableViewController.swift
//  Buy first DDD
//
//  Created by user on 6/27/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

final class StartTableViewController: UITableViewController {

    // MARK: - Props

    var props: Props = .initial
    struct Props {
        let title: String
        let itemName: String
        let onSearch: (String) -> Void

        static let initial = Props(title: "",
                                   itemName: "",
                                   onSearch: { _ in })
    }

    func render(props: Props) {
        self.props = props
        title = props.title
        if self.isViewLoaded {
            nameTextField.text = props.itemName
            tableView.reloadData()
        }
    }

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet var baseTableView: UITableView!
    var retainedObject: AnyObject?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        addGradientLayer()
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: - Actions

    @IBAction func startButtonDidPressed(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty else {
            return
        }
        props.onSearch(name)
    }

    // MARK : Private

    private func addGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.orange.cgColor, UIColor.magenta.cgColor]
        gradient.locations =  [-0.5, 1.5]

        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = [UIColor.orange.cgColor, UIColor.blue.cgColor]
        animation.toValue = [UIColor.blue.cgColor, UIColor.orange.cgColor]
        animation.duration = 10.0
        animation.autoreverses = true
        animation.repeatCount = Float.infinity

        gradient.add(animation, forKey: nil)
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.layer.insertSublayer(gradient, at: 0)
        baseTableView.backgroundView = backgroundView
    }
}

// MARK: - UITextFieldDelegate

extension StartTableViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.endEditing(true)
        return true
    }
}
