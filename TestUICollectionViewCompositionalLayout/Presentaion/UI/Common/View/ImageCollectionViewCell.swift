//
//  ImageCollectionViewCell.swift
//  TestUICollectionViewCompositionalLayout
//
//  Created by Kosuke Matsuda on 2020/10/13.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!

    private var task: URLSessionTask?
    private var url: URL?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.contentMode = .scaleAspectFill
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    deinit {
        stopFetch()
    }

    func fetch(url: URL) {
        if url != self.url {
            imageView.image = nil
        }
        self.url = url
        task = ImageDownloader.shared.loadImage(with: url, completion: { [weak self] (image, _) in
            if let image = image {
                self?.imageView.image = image
            } else {
                self?.imageView.image = .noImage
            }
        })
    }

    func stopFetch() {
        task?.cancel()
        task = nil
    }
}
