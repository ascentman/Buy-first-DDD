//
//  ResultsViewController.swift
//  Buy first DDD
//
//  Created by user on 6/24/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

final class ResultsViewController: UIViewController {

    @IBOutlet private weak var reloadSwitch: UISwitch!
    @IBOutlet private weak var resultsLabel: UILabel!
    @IBOutlet private weak var resultsTableView: UITableView!
    @IBOutlet private weak var itemActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var statusLabel: UILabel!

    let webView = WKWebView()
    var items: [Item] = []
    var timer = Timer()
    var onGenerateRequest: () -> Void = {}

    var retainedObject: AnyObject?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupWebView()
        resultsTableView.tableFooterView = UIView()
        webView.navigationDelegate = self

        statusLabel.text = "Loading"
        itemActivityIndicator.isHidden = false
        itemActivityIndicator.startAnimating()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        webView.stopLoading()
    }

    @IBAction func switchDidTapped(_ sender: Any) {
        if reloadSwitch.isOn {
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: .common)
        } else {
            timer.invalidate()
        }
    }

    @objc func timerAction() {
        itemActivityIndicator.isHidden = false
        itemActivityIndicator.startAnimating()
        statusLabel.text = "Loading"
        resultsTableView.alpha = 0.7
        onGenerateRequest()
    }

    // MARK: - Private

    private func setupWebView() {
        webView.frame = CGRect(x: 300, y: 400, width: 1, height: 1)
        webView.layer.borderColor = UIColor.red.cgColor
        webView.layer.borderWidth = 1.0
        webView.backgroundColor = .orange
        webView.isHidden = true
        view.addSubview(webView)
    }
}


// MARK: - Extensions

extension WKWebView {
    func loadUrl(string: String) {
        if let url = URL(string: string) {
            DispatchQueue.main.async { [weak self] in
                self?.load(URLRequest(url: url))
            }
        }
    }
}

extension ResultsViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async { [weak self] in
            self?.webView.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML") { [weak self] (value, error) in
                do {
                    let response = try EbayResponse(value)
                    self?.items = response.items
                    self?.itemActivityIndicator.stopAnimating()
                    self?.statusLabel.text = "Loaded"
                    self?.resultsTableView.alpha = 1.0
                    self?.resultsTableView.reloadData()
                } catch {}
            }
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: items[indexPath.row].detailsLink) {
            let svc = SFSafariViewController(url: url)
            svc.preferredControlTintColor = UIColor.orange
            present(svc, animated: true, completion: nil)
        }
    }
}
