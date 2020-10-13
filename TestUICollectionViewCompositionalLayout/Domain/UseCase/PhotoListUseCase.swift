//
//  PhotoListUseCase.swift
//  TestUICollectionViewCompositionalLayout
//
//  Created by Kosuke Matsuda on 2020/10/13.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation

// MARK: - PhotoListUseCase

protocol PhotoListUseCase {
    func list(page: Int?,
              limit: Int?,
              completion: @escaping (Result<PhotoList, Error>) -> Void)
}


// MARK: - PhotoListRepository

protocol PhotoListRepository {
    func list(page: Int?,
              limit: Int?,
              completion: @escaping (Result<PhotoList, Error>) -> Void)
}


// MARK: - PhotoListUseCaseImpl

final class PhotoListUseCaseImpl: PhotoListUseCase {
    let repository: PhotoListRepository

    init(respository: PhotoListRepository) {
        self.repository = respository
    }

    func list(page: Int?,
              limit: Int?,
              completion: @escaping (Result<PhotoList, Error>) -> Void) {
        repository.list(page: page,
                        limit: limit,
                        completion: completion)
    }
}
