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

private enum HTMLError: Error {
    case badResponse
}

final class ResultsViewController: UIViewController {

    @IBOutlet private weak var reloadSwitch: UISwitch!
    @IBOutlet private weak var resultsTableView: UITableView!
    @IBOutlet private weak var activityIndicatorView: NVActivityIndicatorView!

    let webView = WKWebView()
    var items: [Item] = []
    var iterationItems: [Item] = []
    var timer = Timer()
    var onGenerateRequest: () -> Void = {}

    var retainedObject: AnyObject?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Results"
        setupWebView()
        resultsTableView.tableFooterView = UIView()
        webView.navigationDelegate = self

        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        webView.stopLoading()
    }

    @IBAction func switchDidTapped(_ sender: Any) {
        LocalNotificationsService.shared.registerLocalNotifications()

        if reloadSwitch.isOn {
            let banner = createBanner()
            banner.show(duration: 3.0)
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: .common)
        } else {
            timer.invalidate()
        }
    }

    @objc func timerAction() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        resultsTableView.alpha = 0.7
        onGenerateRequest()
    }

    // MARK: - Private

    private func createBanner() -> Banner {
        let banner = Banner(title: "Info", subtitle: "Please don't lock your device when continuous update enabled!", image: UIImage(named: "info"), backgroundColor: .purple, didTapBlock: nil)
        banner.dismissesOnTap = true
        banner.position = .bottom
        return banner
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

                    for i in 3..<13 {
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
                        LocalNotificationsService.shared.sendNotification()
                        self?.items = iterItems
                    } else {
                        self?.items = iterItems
                    }

                    DispatchQueue.main.async {
                        self?.activityIndicatorView.stopAnimating()
                        self?.activityIndicatorView.isHidden = true
                        self?.resultsTableView.alpha = 1.0
                        self?.resultsTableView.reloadData()
                    }

                } catch {}
            }
        }


//        DispatchQueue.main.async { [weak self] in
//            self?.webView.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML") { [weak self] (value, error) in
//                do {
//                    let response = try EbayResponse(value)
//                    self?.items = response.items
//                    self?.activityIndicatorView.stopAnimating()
//                    self?.activityIndicatorView.isHidden = true
//                    self?.resultsTableView.alpha = 1.0
//                    self?.resultsTableView.reloadData()
//                } catch {}
//            }
//        }
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


extension Array where Element: Equatable {
    func containSameElements(_ array: [Element]) -> Bool {
        var selfCopy = self
        var secondArrayCopy = array
        while let currentItem = selfCopy.popLast() {
            if let indexOfCurrentItem = secondArrayCopy.firstIndex(of: currentItem) {
                secondArrayCopy.remove(at: indexOfCurrentItem)
            } else {
                return false
            }
        }
        return secondArrayCopy.isEmpty
    }
}
