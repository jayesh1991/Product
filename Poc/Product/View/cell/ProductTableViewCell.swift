//
//  ProductTableViewCell.swift
//  Poc
//
//  Created by jayesh rajput on 14/04/25.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    static let identifier = Constants.Identifier.prodCellIdentifier
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var currentURL: URL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productImage.layer.cornerRadius = 10
        productImage.clipsToBounds = true
        productImage.image = Constants.AppImages.noImagePalceholder.image
    }
    
    func configure(with product: Product) {
        productNameLabel.text = product.title
        priceLabel.text = "$\(product.price)"
        activityIndicator.startAnimating()
        
        guard let url = URL(string: product.image) else {
            return
        }
        currentURL = url
        
        ImageCacheManager.sharedInstance.downLoadImage(url: url) { [weak self] image in
            guard let selfRef = self else { return }
            DispatchQueue.main.async {
                if selfRef.currentURL == url {
                    selfRef.productImage.image = image ?? Constants.AppImages.noImagePalceholder.image
                    selfRef.activityIndicator.stopAnimating()
                    selfRef.activityIndicator.isHidden = true
                }
            }
        }
    }
    
    override func prepareForReuse() {
        productImage.image = Constants.AppImages.noImagePalceholder.image
        currentURL = nil
    }
}
