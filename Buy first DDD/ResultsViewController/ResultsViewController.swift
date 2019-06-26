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

    @IBOutlet private weak var reloadSwitch: UISwitch!
    @IBOutlet private weak var resultsLabel: UILabel!
    @IBOutlet private weak var resultsTableView: UITableView!
    let webView = WKWebView()
    var items: [Item] = []
    var timer = Timer()

    var retainedObject: AnyObject?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupWebView()
        resultsTableView.tableFooterView = UIView()
        resultsTableView.delegate = self
        webView.navigationDelegate = self
    }

    // MARK: - Private

    private func setupWebView() {
        webView.frame = CGRect(x: 2, y: 400, width: view.bounds.width - 5, height: view.bounds.height / 2.5 - 5)
        webView.layer.borderColor = UIColor.red.cgColor
        webView.layer.borderWidth = 1.0
        webView.backgroundColor = .orange
        webView.isHidden = true
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
        webView.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML") { [weak self] (value, error) in
            do {
                let response = try EbayResponse(value)
                self?.items = response.items
                self?.resultsLabel.text = response.totalResults
                self?.resultsTableView.reloadData()
            } catch {}
        }
    }
}

extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = resultsTableView.dequeueReusableCell(withIdentifier: "cell") as? ItemTableViewCell else {
            return UITableViewCell()
        }

        cell.setupCell(item: items[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
