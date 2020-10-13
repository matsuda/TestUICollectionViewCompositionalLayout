//
//  LoadingCollectionViewCell.swift
//  TestUICollectionViewCompositionalLayout
//
//  Created by Kosuke Matsuda on 2020/10/13.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import UIKit

final class LoadingCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func startAnimating() {
        indicatorView.startAnimating()
    }

    func stopAnimating() {
        indicatorView.stopAnimating()
    }
}
