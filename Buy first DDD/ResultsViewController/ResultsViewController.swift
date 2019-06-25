//
//  ResultsViewController.swift
//  Buy first DDD
//
//  Created by user on 6/24/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import WebKit

final class ResultsViewController: UIViewController {

    // MARK: - Props

    var props: Props = .initial
    struct Props {
        let title: String
        let results: String
        let lastResults: String
        let items: [Item]

        struct Item {
            let name: String
            let price: String
            let image: UIImage
            let onSelectItem: () -> Void
        }

        static let initial: Props = Props(title: "", results: "", lastResults: "", items: [])
    }

    func render(props: Props) {
        self.props = props
        title = props.title
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var reloadSwitch: UISwitch!
    @IBOutlet private weak var resultsLabel: UILabel!
    @IBOutlet private weak var resultsTableView: UITableView!
    let webView = WKWebView()

    var retainedObject: AnyObject?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        render(props: props)
        setupWebView()
//        resultsTableView.tableFooterView = UIView()
        resultsTableView.delegate = self
        webView.navigationDelegate = self
    }

    // MARK: - Private

    private func setupWebView() {
        webView.frame = CGRect(x: 2, y: 400, width: view.bounds.width - 5, height: view.bounds.height / 2.5 - 5)
        webView.layer.borderColor = UIColor.red.cgColor
        webView.layer.borderWidth = 1.0
        webView.backgroundColor = .orange
//        webView.isHidden = true
        view.addSubview(webView)
    }
}


// MARK: - Extensions

extension WKWebView {
    func loadUrl(string: String, completion: () -> ()) {
        if let url = URL(string: string) {
            print(url)
            load(URLRequest(url: url))
        }
        completion()
    }
}

extension ResultsViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML") { (value, error) in
            print("loaded!!!!!!!")
        }
    }
}

extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return props.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = resultsTableView.dequeueReusableCell(withIdentifier: "cell") as? ItemTableViewCell else {
            return UITableViewCell()
        }
        cell.nameLabel.text = props.items[indexPath.row].name
        cell.priceLabel.text = props.items[indexPath.row].price
        cell.itemImageView.image = props.items[indexPath.row].image
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
