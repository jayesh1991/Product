//
//  ProductDetailViewController.swift
//  Poc
//
//  Created by jayesh rajput on 15/04/25.
//

import Foundation
import UIKit

class ProductDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: ProductDetailViewModelType
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let priceLabel = UILabel()
    private let addToCartButton = UIButton(type: .system)
    
    // MARK: - Init
    init(viewModel: ProductDetailViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationUI()
        setupUI()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    // MARK: - Private Functions
    
    private func navigationUI() {
        title = "Product Details"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Constants.SystemImages.back.image, style: .plain, target: self, action: #selector(handleBack))
    }
    
    @objc private func handleBack() {
        if let nav = navigationController {
            nav.popViewController(animated: true)
        }
    }
    
    private func setupUI() {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        nameLabel.font = .boldSystemFont(ofSize: 20)
        nameLabel.numberOfLines = 0
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        priceLabel.font = .boldSystemFont(ofSize: 20)
        priceLabel.textColor = .systemIndigo
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addToCartButton.setTitle("Add to Cart", for: .normal)
        addToCartButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        addToCartButton.backgroundColor = .systemIndigo
        addToCartButton.tintColor = .white
        addToCartButton.layer.cornerRadius = 10
        addToCartButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [imageView, nameLabel, priceLabel, descriptionLabel, addToCartButton])
        stack.axis = .vertical
        stack.spacing = 15
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }
    
    private func configureUI() {
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        priceLabel.text = viewModel.price
        
        if let url = viewModel.imageURL {
            viewModel.loadImage(from: url) { [weak self] image in
                guard let selfRef = self else {
                    return
                }
                DispatchQueue.main.async {
                    selfRef.imageView.image = image ?? Constants.AppImages.noImagePalceholder.image
                }
            }
        } else {
            imageView.image = Constants.AppImages.noImagePalceholder.image
        }
    }
    
    @objc private func addToCart() {
        if !viewModel.checkProductAddedToCart() {
            viewModel.addToCart()
            showAlert(title: Constants.Message.addedMsg, message: Constants.Message.prodcutAdded)
        } else {
            showAlert(title: Constants.Message.errorMsg, message: Constants.Message.prodcutAlreadyAdded)
        }
    }
}
