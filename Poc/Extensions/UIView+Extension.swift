//
//  UIView+Extension.swift
//  Poc
//
//  Created by jayesh rajput on 15/04/25.
//

import Foundation
import UIKit

extension UIView {
    static func emptyView(message: String) -> UIView {
        let containerView = UIView(frame: .zero)
        let label = UILabel()
        label.text = message
        label.font = .systemFont(ofSize: 18)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        return containerView
    }
}
