//
//  PhotoListRepository.swift
//  TestUICollectionViewCompositionalLayout
//
//  Created by Kosuke Matsuda on 2020/10/13.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation
import API

// MARK: - PhotoListRepositoryImpl

final class PhotoListRepositoryImpl: PhotoListRepository {
    func list(page: Int?,
              limit: Int?,
              completion: @escaping (Result<PhotoList, Error>) -> Void) {
        let request = PhotoListRequest(page: page, limit: limit)
        Session.shared.send(request) { (result) in
            switch result {
            case .success(let response):
                let entity = PhotoList(photoListResponse: response)
                completion(.success(entity))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


// MARK: - PhotoList

extension PhotoList {
    init(photoListResponse response: [API.Photo]) {
        photoList = response.map(Photo.init(photo:))
    }
}


// MARK: - Photo

extension Photo {
    init(photo: API.Photo) {
        id = photo.id
        imageURL = photo.imageURL
    }
}
