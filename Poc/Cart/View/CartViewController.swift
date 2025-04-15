//
//  CartViewController.swift
//  Poc
//
//  Created by jayesh rajput on 15/04/25.
//

import Foundation
import UIKit

class CartViewController: UITableViewController {
    
    private var viewModel: CartViewModelType
    private var tableHeight: CGFloat = 120.0
    
    // MARK: - Init
    init(viewModel: CartViewModelType) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationUI()
        setupUI()
        
        viewModel.fetchCartItems()
    }
    
    // MARK: - Private Functions
    
    private func navigationUI() {
        title = "Cart"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Constants.SystemImages.back.image, style: .plain, target: self, action: #selector(handleBack))
    }
    
    @objc private func handleBack() {
        if let nav = navigationController {
            nav.popViewController(animated: true)
        }
    }
    
    private func setupUI() {
        let nib = UINib(nibName: CartTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: CartTableViewCell.identifier)
        addEmptyView()
        viewModel.onCartUpdated = { [weak self] in
            guard let selfRef = self else { return }
            selfRef.tableView.reloadData()
            selfRef.setupFooterView()
            selfRef.addEmptyView()
        }
        setupFooterView()
    }
    
    private func addEmptyView() {
        if viewModel.numberOfItems() > 0 {
            tableView.tableHeaderView = nil
        } else {
            let emptyHeader = UIView.emptyView(message: Constants.Message.noProductFound)
            emptyHeader.frame.size.height = tableView.frame.size.height
            tableView.tableHeaderView = emptyHeader
        }
    }
    
    private func setupFooterView() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = "Total: $\(viewModel.totalCartPrice())"
        footerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -20),
            label.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])
        
        tableView.tableFooterView = footerView
    }
}

// MARK: - Tableview Delegate and Datasource

extension CartViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier, for: indexPath) as? CartTableViewCell else {
            return UITableViewCell()
        }
        let item = viewModel.item(at: indexPath.row)
        cell.configure(with: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableHeight
    }
}
