//
//  UICollectionView+Extensions.swift
//  Library
//
//  Created by Kosuke Matsuda on 2020/10/16.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewCell

extension UICollectionReusableView: Reusable {}


// MARK: - UICollectionView

extension UICollectionView {
    public func registerNib<T: UICollectionViewCell>(_ type: T.Type) {
        let identifier = T.reusableIdentifier
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: identifier, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: identifier)
    }

    public func registerClass<T: UICollectionViewCell>(_ type: T.Type) {
        let identifier = T.reusableIdentifier
        register(T.self, forCellWithReuseIdentifier: identifier)
    }

    public func dequeueReusableCell<T: UICollectionViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        let identifier = T.reusableIdentifier
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell: \(T.self) with identifier: \(identifier).")
        }
        return cell
    }

    public func registerNib<T: UICollectionReusableView>(_ type: T.Type, forSupplementaryViewOfKind kind: String) {
        let identifier = T.reusableIdentifier
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: identifier, bundle: bundle)
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }

    public func registerClass<T: UICollectionReusableView>(_ type: T.Type, forSupplementaryViewOfKind kind: String) {
        let identifier = T.reusableIdentifier
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }

    public func dequeueReusableSupplementaryView<T: UICollectionReusableView>(_ type: T.Type, ofKind elementKind: String, for indexPath: IndexPath) -> T {
        let identifier = T.reusableIdentifier
        guard let view = dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue supplementaryView: \(T.self) with identifier: \(identifier).")
        }
        return view
    }
}
