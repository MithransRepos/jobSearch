//
//  UIImageViewExtension.swift
//  jobSearch
//
//  Created by MithranN on 08/03/20.
//  Copyright © 2020 MithranN. All rights reserved.
//

import UIKit

public extension UIImageView {
    func setImage(fromURL url: String?) {
        guard let urlString = url,  let imageURL = URL(string: urlString) else {
            return
        }
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        self.addSubview(activityIndicator)
        let cache =  URLCache.shared
        let request = URLRequest(url: imageURL)
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                    self.transition(toImage: image)
                    activityIndicator.stopAnimating()
                }
            } else {
                DispatchQueue.main.async {
                    activityIndicator.startAnimating()
                }
                URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                        let cachedData = CachedURLResponse(response: response, data: data)
                        cache.storeCachedResponse(cachedData, for: request)
                        DispatchQueue.main.async {
                            self.transition(toImage: image)
                            activityIndicator.stopAnimating()
                        }
                    }
                }).resume()
            }
        }
    }
    
    func transition(toImage image: UIImage?) {
        UIView.transition(with: self, duration: 0.3,
                          options: [.transitionCrossDissolve],
                          animations: {
                            self.image = image
        },
                          completion: nil)
    }
}
