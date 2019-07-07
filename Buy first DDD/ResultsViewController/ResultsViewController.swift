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
import NVActivityIndicatorView
import BRYXBanner
import SwiftSoup
import AudioToolbox

private enum HTMLError: Error {
    case badResponse
}

final class ResultsViewController: UIViewController {

    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var resultsTableView: UITableView!
    @IBOutlet private weak var activityIndicatorView: NVActivityIndicatorView!

    let webView = WKWebView()
    private var items: [Item] = []
    private var iterationItems: [Item] = []
    private var timer = Timer()
    var onGenerateRequest: () -> Void = {}

    var retainedObject: AnyObject?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Results"
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        setupWebView()
        resultsTableView.tableFooterView = UIView()
        webView.navigationDelegate = self

        if !NetworkService.isConnectedToNetwork() {
            createErrorBanner()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if UserDefaults.standard.continuousReload {
            statusLabel.text = "enabled"
            setupContinuousLoading()
        } else {
            statusLabel.text = "disabled"
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        webView.stopLoading()
    }

    @objc func timerAction() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        resultsTableView.alpha = 0.7
        if self == navigationController?.topViewController {
            onGenerateRequest()
        }
    }

    // MARK: - Private

    private func setupContinuousLoading() {
        if UserDefaults.standard.continuousReload {
            let banner = createInfoBanner()
            banner.show(duration: 3.0)
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: Double(UserDefaults.standard.reloadTimeInterval), target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: .common)
        } else {
            timer.invalidate()
            webView.stopLoading()
            activityIndicatorView.stopAnimating()
            activityIndicatorView.isHidden = true
            resultsTableView.alpha = 1.0
        }
    }

    private func createInfoBanner() -> Banner {
        let banner = Banner(title: "Info", subtitle: "Please don't lock your device when continuous update enabled!", image: UIImage(named: "info"), backgroundColor: .purple, didTapBlock: nil)
        banner.dismissesOnTap = true
        banner.position = .bottom
        return banner
    }

    private func showResultBanner() {
        let banner = Banner(title: "Info", subtitle: "Displaying last \(UserDefaults.standard.itemsCount) added on website items", image: UIImage(named: "present"), backgroundColor: .orange, didTapBlock: nil)
        banner.dismissesOnTap = true
        banner.position = .bottom
        banner.show(duration: 3.0)
    }

    private func createErrorBanner() {
        let banner = Banner(title: "Error", subtitle: "No Internet connection", image: UIImage(named: "error"), backgroundColor: .red, didTapBlock: nil)
        banner.dismissesOnTap = true
        banner.position = .bottom
        banner.show(duration: 2.0)
    }

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

        webView.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML") { [weak self] (value, error) in

            DispatchQueue.global().async {
                do {
                    guard let htmlString = value as? String else {
                        throw HTMLError.badResponse
                    }
                    let document = try SwiftSoup.parse(htmlString)
                    let itemTitles = try document.getElementsByClass("s-item__title").array()
                    let itemPrices = try document.getElementsByClass("s-item__price").array()
                    let itemImages = try document.getElementsByClass("s-item__image-img").array()
                    let itemLink = try document.getElementsByClass("s-item__link").array()

                    self?.iterationItems = []
                    for i in 0..<UserDefaults.standard.itemsCount {
                        let name = try itemTitles[i + 1].text()
                        let price = try itemPrices[i].text()
                        let imageAbsolutePath = try itemImages[i].attr("src")
                        let detailsLink = try itemLink[i].attr("href")

                        let item = Item(name: name,
                                        price: price,
                                        imageAbsolutePath: imageAbsolutePath,
                                        detailsLink: detailsLink)
                        self?.iterationItems.append(item)
                    }
                    
                    guard let items = self?.items, let iterItems = self?.iterationItems else {
                        return
                    }

                    if items != iterItems,
                        !items.isEmpty {
                        AudioServicesPlayAlertSound(1315)
                        self?.items = iterItems
                    } else {
                        self?.items = iterItems
                    }

                    DispatchQueue.main.async {
                        self?.activityIndicatorView.stopAnimating()
                        self?.activityIndicatorView.isHidden = true
                        self?.showResultBanner()
                        self?.resultsTableView.alpha = 1.0
                        self?.resultsTableView.reloadData()
                    }

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
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let url = URL(string: items[indexPath.row].detailsLink) {
            let svc = SFSafariViewController(url: url)
            svc.preferredControlTintColor = UIColor.orange
            present(svc, animated: true, completion: nil)
        }
    }
}
