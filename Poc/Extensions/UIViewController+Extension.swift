//
//  UIViewController+Extension.swift
//  Poc
//
//  Created by jayesh rajput on 14/04/25.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String = "Error", message: String, buttonTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default))
        present(alert, animated: true)
    }
}
