//
//  ProductListViewModel.swift
//  Poc
//
//  Created by jayesh rajput on 14/04/25.
//

import Foundation
import Combine

protocol ProductListViewModelType {
    var products: [Product] { get }
    var onDataUpdate: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    var onSelectProduct: ((Product) -> Void)? { get set }
    var onCartTapped: (() -> Void)? { get set }
    
    func fetchProducts()
    func didTapCart()
    func didSelectItem(at index: Int)
}

class ProductListViewModel: ProductListViewModelType {
    
    // MARK: - Properties
    var products: [Product] = []
    private var page = 0
    private let limit = 10
    private var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    private var currentFetchCancellable: AnyCancellable?
    private var dependency: ProductViewModelDependencyType
    
    var onDataUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    var onSelectProduct: ((Product) -> Void)?
    var onCartTapped: (() -> Void)?
    
    // MARK: - Init
    init(dependency: ProductViewModelDependencyType = ProductViewModelDependency()) {
        self.dependency = dependency
    }
    
    func fetchProducts() {
        guard !isLoading else { return }
        isLoading = true
        
        // cancel previous ongoing network request before starting new request
        currentFetchCancellable?.cancel()
        currentFetchCancellable = nil
        
        let endpoint = Constants.API.Endpoint.products(limit: limit, skip: page * limit).url
        
        currentFetchCancellable = dependency.networkManager.request(
            endpoint: endpoint,
            method: .GET,
            body: Optional<String>.none,
            responseType: Products.self
        )
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { [weak self] completion in
            guard let selfRef = self else { return }
            selfRef.isLoading = false
            selfRef.currentFetchCancellable = nil
            if case .failure(let error) = completion {
                let message = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
                selfRef.onError?(message)
            }
        }, receiveValue: { [weak self] newProducts in
            guard let selfRef = self else { return }
            let newProductArray = Array(newProducts.products)
            guard !newProductArray.isEmpty else {
                self?.onError?(Constants.Message.noProductFound)
                return
            }
            selfRef.products.append(contentsOf: newProductArray)
            selfRef.page += 1
            selfRef.onDataUpdate?()
        })
    }
    
    func didSelectItem(at index: Int) {
        let selectedProduct = products[index]
        onSelectProduct?(selectedProduct)
    }
    
    func didTapCart() {
        onCartTapped?()
    }
}
