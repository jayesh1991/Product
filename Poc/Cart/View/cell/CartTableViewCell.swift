//
//  CartCell.swift
//  Poc
//
//  Created by jayesh rajput on 15/04/25.
//

import Foundation
import UIKit

class CartTableViewCell: UITableViewCell {
    
    static let identifier = Constants.Identifier.cartCellIdentifier

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        productImageView.contentMode = .scaleAspectFit
        productImageView.layer.cornerRadius = 8
        productImageView.clipsToBounds = true
    }

    func configure(with product: CartProduct) {
        nameLabel.text = product.name
        priceLabel.text = "$\(product.price)"

        productImageView.image = Constants.AppImages.noImagePalceholder.image

        if let urlString = product.imageUrl,
           let url = URL(string: urlString) {
            ImageCacheManager.sharedInstance.downLoadImage(url: url) { [weak self] image in
                DispatchQueue.main.async {
                    self?.productImageView.image = image
                }
            }
        }
    }
}
