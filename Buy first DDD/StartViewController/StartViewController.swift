//
//  StartTableViewController.swift
//  Buy first DDD
//
//  Created by user on 6/27/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import AudioToolbox
import SkyFloatingLabelTextField

final class StartViewController: UIViewController {

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
            view.layoutIfNeeded()
        }
    }

    // MARK: - IBOutlets


    @IBOutlet private weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var searchButton: UIButton!
    var retainedObject: AnyObject?

    private var cartLayer: CALayer?
    private var presentLayer: CALayer?
    private var nameLayer: CATextLayer?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addAnimations()
        nameTextField.tintColor = .orange
        setupDefaultsSettings()
        nameTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
    }

    // MARK: - Actions

    @IBAction func startButtonDidPressed(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty, name.isAlphanumericWithSpace else {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            nameTextField.shake()
            return
        }
        nameTextField.endEditing(true)
        searchButton.pulse(completion: { [weak self] in
            self?.props.onSearch(name)
        })
    }

    // MARK : Private

    @objc private func textFieldDidChange(_ textfield: UITextField) {
        if let text = nameTextField.text {
            if text.isAlphanumericWithSpace || text.isEmpty {
                nameTextField.errorMessage = ""
            } else {
                nameTextField.errorMessage = "Invalid characters"
            }
        }
    }

    private func setupDefaultsSettings() {
        if !UserDefaults.standard.isItemsCountPresentInUserDefaults() {
            UserDefaults.standard.updateItemsCount(4)
        }

        if !UserDefaults.standard.isItemsReloadTimeIntervalPresentInUserDefaults() {
            UserDefaults.standard.updateReloadTimeInterval(60)
        }

        if !UserDefaults.standard.isItemsContinuousReloadPresentInUserDefaults() {
            UserDefaults.standard.updateContinuousReload(true)
        }
    }

    private func addAnimations() {
        addCartAnimation(completion: { [weak self] in
            self?.addPresentAnimation(completion: { [weak self] in
                self?.addFullCartAnimation(completion: { [weak self] in
                    self?.addShakeAnimation(completion: { [weak self] in
                        self?.addAnimatedText()
                    })
                })
            })
        })
    }

    private func addCartAnimation(completion: @escaping () -> ()) {
        let cartLayer = CALayer()
        let myImage = UIImage(named: "shoppingCart")?.maskWithColor(color: .white)?.cgImage
        cartLayer.frame = CGRect(x: -100, y: 150, width: 100, height: 100)
        cartLayer.position = CGPoint(x: view.frame.width / 2, y: 200)
        cartLayer.contents = myImage

        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = [-10, 200]
        animation.toValue = [view.frame.width / 2 , 200]
        animation.duration = 1.3
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        cartLayer.add(animation, forKey: nil)
        view.layer.addSublayer(cartLayer)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion()
        }
        self.cartLayer = cartLayer
    }

    private func addPresentAnimation(completion: @escaping () -> ()) {
        let presentLayer = CALayer()
        let myImage = UIImage(named: "present")?.cgImage
        presentLayer.frame = CGRect(x: -50, y: 0, width: 60, height: 60)
        presentLayer.position = CGPoint(x: view.frame.width / 2 + 10, y: 180)
        presentLayer.contents = myImage

        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = [view.frame.width / 2 + 10, 0]
        animation.toValue = [view.frame.width / 2  + 10, 180]
        animation.duration = 0.7
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        presentLayer.add(animation, forKey: nil)
        view.layer.insertSublayer(presentLayer, at: 1)
        self.presentLayer = presentLayer

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            completion()
        }
    }

    private func addFullCartAnimation(completion: @escaping () -> ()) {
        let animation1 = CABasicAnimation(keyPath: "position")
        let animation2 = CABasicAnimation(keyPath: "position")
        animation1.fromValue = [view.frame.width / 2 , 200]
        animation1.toValue = [view.frame.width + 100 , 200]
        animation1.duration = 1.5
        animation1.isRemovedOnCompletion = false
        animation1.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation2.fromValue = [view.frame.width / 2 + 10 , 180]
        animation2.toValue = [view.frame.width + 110 , 180]
        animation2.duration = 1.5
        animation2.isRemovedOnCompletion = false
        animation2.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        guard let cartLayer = cartLayer, let presentLayer = presentLayer else {
            return
        }
        cartLayer.add(animation1, forKey: nil)
        presentLayer.add(animation2, forKey: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion()
        }
    }

    private func addShakeAnimation(completion: @escaping () -> ()) {
        guard let cartLayer = cartLayer, let presentLayer = presentLayer else {
            return
        }

        let animation1 = CABasicAnimation(keyPath: "transform.rotation")
        let animation2 = CABasicAnimation(keyPath: "transform.rotation")
        animation1.fromValue = -CGFloat(Double.pi / 20)
        animation1.toValue = CGFloat(Double.pi / 20)
        animation1.duration = 0.1
        animation1.repeatCount = 5
        animation1.autoreverses = true
        animation1.isRemovedOnCompletion = true
        animation1.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation2.fromValue = -CGFloat(Double.pi / 20)
        animation2.toValue = CGFloat(Double.pi / 20)
        animation2.duration = 0.1
        animation2.repeatCount = 5
        animation2.autoreverses = true
        animation2.isRemovedOnCompletion = true
        animation2.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

        cartLayer.add(animation1, forKey: nil)
        presentLayer.add(animation2, forKey: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion()
        }
    }


    private func addAnimatedText() {
        let myAttributes = [
            NSAttributedString.Key.font: UIFont(name: "ChalkboardSE-Bold", size: 44.0)! ,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        let myAttributedString = NSAttributedString(string: "Buy first", attributes: myAttributes )

        let textLayer = CATextLayer()
        textLayer.string = myAttributedString
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.frame = CGRect(x: view.bounds.width / 2 - textLayer.preferredFrameSize().width / 2, y: 50, width: 200, height: 100)

        let animationOpacity = CABasicAnimation(keyPath: "opacity")
        let animationScaling = CABasicAnimation(keyPath: "transform.scale.x")
        animationOpacity.fromValue = 0
        animationOpacity.toValue = 1
        animationScaling.fromValue = 0.9
        animationScaling.toValue = 1
        let animationGroup = CAAnimationGroup()
        animationGroup.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animationGroup.duration = 1.5
        animationGroup.animations = [animationOpacity, animationScaling]
        textLayer.add(animationGroup, forKey: nil)
        view.layer.addSublayer(textLayer)
        self.nameLayer = textLayer
    }

    private func addShakeAnimation() {
        guard let cartLayer = cartLayer, let presentLayer = presentLayer else {
            return
        }

        let animation1 = CABasicAnimation(keyPath: "transform.rotation")
        let animation2 = CABasicAnimation(keyPath: "transform.rotation")
        animation1.fromValue = -CGFloat(Double.pi / 20)
        animation1.toValue = CGFloat(Double.pi / 20)
        animation1.duration = 0.1
        animation1.repeatCount = 5
        animation1.autoreverses = true
        animation1.isRemovedOnCompletion = true
        animation1.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation2.fromValue = -CGFloat(Double.pi / 20)
        animation2.toValue = CGFloat(Double.pi / 20)
        animation2.duration = 0.1
        animation2.repeatCount = 5
        animation2.autoreverses = true
        animation2.isRemovedOnCompletion = true
        animation2.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

        cartLayer.add(animation1, forKey: nil)
        presentLayer.add(animation2, forKey: nil)
    }
}

// MARK: - UITextFieldDelegate

extension StartViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.endEditing(true)
        return true
    }
}
