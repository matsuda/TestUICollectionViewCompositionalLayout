//
//  PhotoListViewData.swift
//  TestUICollectionViewCompositionalLayout
//
//  Created by Kosuke Matsuda on 2020/10/13.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation

enum PhotoListViewData {

    // MARK: - Section

    enum Section: Int, CaseIterable {
        case photoList
        case loading
    }


    // MARK: - Photo

    struct Photo: Hashable {
        let id: String
        let imageURL: URL


        // Hashable

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        static func == (lhs: Photo, rhs: Photo) -> Bool {
            return lhs.id == rhs.id
        }
    }
}


// MARK: - PhotoListViewData.Photo

extension PhotoListViewData.Photo {
    init(photo: Photo) {
        id = photo.id
        imageURL = photo.imageURL
    }
}
