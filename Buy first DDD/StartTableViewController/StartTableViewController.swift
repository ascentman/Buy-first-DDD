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

    // MARK: - IBOutlets

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet var baseTableView: UITableView!
    var retainedObject: AnyObject?

    private var backgroundView: UIView!
    private var gradientLayer: CAGradientLayer?
    private var cartLayer: CALayer?
    private var presentLayer: CALayer?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        backgroundView = UIView(frame: view.bounds)
        baseTableView.backgroundView = backgroundView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        addGradientLayer()
        addCartAnimation(completion: { [weak self] in
            self?.addPresentAnimation(completion: { [weak self] in
                self?.addFullCartAnimation(completion: { [weak self] in
                    self?.addShakeAnimation()
                })
            })
        })
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        backgroundView.layer.sublayers = nil
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
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.orange.cgColor, UIColor.magenta.cgColor]
        gradientLayer.locations =  [-0.5, 1.5]

        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = [UIColor.orange.cgColor, UIColor.blue.cgColor]
        animation.toValue = [UIColor.blue.cgColor, UIColor.orange.cgColor]
        animation.duration = 10.0
        animation.autoreverses = true
        animation.repeatCount = Float.infinity

        gradientLayer.add(animation, forKey: nil)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        self.gradientLayer = gradientLayer
    }

    private func addCartAnimation(completion: @escaping () -> ()) {
        let cartLayer = CALayer()
        let myImage = UIImage(named: "shoppingCart")?.maskWithColor(color: .white)?.cgImage
        cartLayer.frame = CGRect(x: -100, y: 150, width: 100, height: 100)
        cartLayer.position = CGPoint(x: view.frame.width / 2, y: 150)
        cartLayer.contents = myImage

        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = [0, 150]
        animation.toValue = [view.frame.width / 2 , 150]
        animation.duration = 1.3
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        cartLayer.add(animation, forKey: nil)
        backgroundView.layer.addSublayer(cartLayer)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion()
        }
        self.cartLayer = cartLayer
    }

    private func addPresentAnimation(completion: @escaping () -> ()) {
        let presentLayer = CALayer()
        let myImage = UIImage(named: "present")?.cgImage
        presentLayer.frame = CGRect(x: -50, y: 0, width: 60, height: 60)
        presentLayer.position = CGPoint(x: view.frame.width / 2 + 10, y: 130)
        presentLayer.contents = myImage

        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = [view.frame.width / 2 + 10, 0]
        animation.toValue = [view.frame.width / 2  + 10, 130]
        animation.duration = 1.3
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        presentLayer.add(animation, forKey: nil)
        backgroundView.layer.insertSublayer(presentLayer, at: 1)
        self.presentLayer = presentLayer

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            completion()
        }
    }

    private func addFullCartAnimation(completion: @escaping () -> ()) {
        let animation1 = CABasicAnimation(keyPath: "position")
        let animation2 = CABasicAnimation(keyPath: "position")
        animation1.fromValue = [view.frame.width / 2 , 150]
        animation1.toValue = [view.frame.width + 100 , 150]
        animation1.duration = 1.5
        animation1.isRemovedOnCompletion = true
        animation1.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation2.fromValue = [view.frame.width / 2 + 10 , 130]
        animation2.toValue = [view.frame.width + 110 , 130]
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

extension StartTableViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.endEditing(true)
        return true
    }
}


extension UIImage {

    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!

        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!

        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)

        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
}
