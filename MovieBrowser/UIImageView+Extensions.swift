//
//  UIImage+Extensions.swift
//  MovieBrowser
//
//  Created by Sandro Shanshiashvili on 14.11.22.
//

import UIKit

extension UIImageView {
    func load(baseURL: String, endpoint: String?) {
        guard let endpoint = endpoint, let url = URL(string: baseURL + endpoint) else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
