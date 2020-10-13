//
//  ImageDownloader.swift
//  TestUICollectionViewCompositionalLayout
//
//  Created by Kosuke Matsuda on 2020/10/13.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import UIKit

// MARK: - ImageDownloader

final class ImageDownloader {
    typealias Completion = (UIImage?, Error?) -> Void

    static let shared: ImageDownloader = .init()

    func loadImage(with url: URL,
                   queue: DispatchQueue = .main,
                   completion: @escaping Completion) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            let image = data.flatMap { UIImage(data: $0) }
            queue.async {
                completion(image, error)
            }
        }
        task.resume()
        return task
    }
}


// MARK: - UIImage

extension UIImage {
    static var noImage: UIImage {
        UIImage(named: "no-image")!
    }
}
