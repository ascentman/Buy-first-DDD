//
//  ItemTableViewCell.swift
//  Buy first DDD
//
//  Created by user on 6/25/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func prepareForReuse() {

        itemImageView.image = nil
        nameLabel.text = ""
        priceLabel.text = ""
    }

    func setupCell(item: Item) {
        itemImageView.downloaded(from: item.imageAbsolutePath)
        nameLabel.text = item.name
        priceLabel.text = item.price
    }
}

// MARK: - Extensions

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
