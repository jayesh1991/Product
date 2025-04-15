//
//  ProductListViewController.swift
//  Poc
//
//  Created by jayesh rajput on 14/04/25.
//

import UIKit

class ProductListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var viewModel: ProductListViewModelType = ProductListViewModel()
    let loadingFooterView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationUI()
        setupUI()
        viewModel.fetchProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Private Functions
    
    private func showErrorAlert(_ message: String) {
        showAlert(message: message)
    }
    
    private func navigationUI() {
        title = "Products"
        navigationBarItem()
    }
    
    private func navigationBarItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: Constants.SystemImages.cartImg.image,
            style: .plain,
            target: self,
            action: #selector(openCart)
        )
    }
    
    @objc func openCart() {
        viewModel.didTapCart()
    }
    
    private func setupUI() {
        let nib = UINib(nibName: ProductTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ProductTableViewCell.identifier)
        tableView.tableFooterView = loadingFooterView
        addEmptyView()
        
        viewModel.onDataUpdate = { [weak self] in
            guard let selfRef = self else { return }
            selfRef.loadingFooterView.stopAnimating()
            selfRef.addEmptyView()
            selfRef.tableView.reloadData()
        }
        
        viewModel.onError = { [weak self] error in
            guard let selfRef = self else { return }
            selfRef.loadingFooterView.stopAnimating()
            selfRef.showErrorAlert(error)
        }
        
        viewModel.onSelectProduct = { [weak self] product in
            guard let selfRef = self else { return }
            let detailViewModel: ProductDetailViewModelType = ProductDetailViewModel(product: product)
            let detailVC = ProductDetailViewController(viewModel: detailViewModel)
            detailVC.navigationItem.largeTitleDisplayMode = .never
            selfRef.navigationController?.pushViewController(detailVC, animated: true)
        }
        
        viewModel.onCartTapped = { [weak self] in
            let cartVM: CartViewModelType = CartViewModel()
            let cartVC = CartViewController(viewModel: cartVM)
            cartVC.navigationItem.largeTitleDisplayMode = .never
            self?.navigationController?.pushViewController(cartVC, animated: true)
        }
    }
    
    private func addEmptyView() {
        if viewModel.products.isEmpty {
            let emptyHeader = UIView.emptyView(message: Constants.Message.noProductFound)
            emptyHeader.frame.size.height = tableView.frame.size.height
            tableView.tableHeaderView = emptyHeader
        } else {
            tableView.tableHeaderView = nil
        }
    }
}

// MARK: - Tableview Delegate and Datasource

extension ProductListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        let product = viewModel.products[indexPath.row]
        cell.configure(with: product)
        
        if indexPath.row == viewModel.products.count - 1 {
            loadingFooterView.startAnimating()
            viewModel.fetchProducts()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
