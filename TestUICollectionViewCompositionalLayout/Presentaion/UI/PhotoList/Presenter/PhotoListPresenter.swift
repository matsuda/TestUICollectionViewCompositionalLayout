//
//  PhotoListPresenter.swift
//  TestUICollectionViewCompositionalLayout
//
//  Created by Kosuke Matsuda on 2020/10/13.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation

// MARK: - PhotoListPhoto

typealias PhotoListPhoto = PhotoListViewData.Photo


// MARK: - PhotoListPresenterOutput

protocol PhotoListPresenterOutput: AnyObject {
    func photoListPresenter(photoListPresenter: PhotoListPresenter, searchPhotoList: [PhotoListPhoto])
    func photoListPresenter(photoListPresenter: PhotoListPresenter, searchError: Error)
}


// MARK: - PhotoListPresenter

final class PhotoListPresenter {
    let useCase: PhotoListUseCase
    weak var output: PhotoListPresenterOutput?

    private let limit = 20
    private var page = 1

    init(useCase: PhotoListUseCase) {
        self.useCase = useCase
    }

    func get(page: Int? = nil) {
        useCase.list(page: page, limit: limit) { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.didSearch(response: response)
            case .failure(let error):
                self?.didSearch(error: error)
            }
        }
    }

    func paging() {
        page += 1
        get(page: page)
    }
}


// MARK: - private

extension PhotoListPresenter {
    private func didSearch(response: PhotoList) {
        let photoList = response.photoList.map(PhotoListPhoto.init(photo:))

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.output?.photoListPresenter(photoListPresenter: self, searchPhotoList: photoList)
        }
    }

    private func didSearch(error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.output?.photoListPresenter(photoListPresenter: self, searchError: error)
        }
    }

    private func resetSearchInfo() {
    }
}


#if DEBUG
import API

extension PhotoListPresenter {
    func loadData() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            if let path = Bundle.main.path(forResource: "list", ofType: "json") {
                let url = URL(fileURLWithPath: path)
                if let data = try? Data(contentsOf: url),
                   let object = try? JSONDecoder().decode([API.Photo].self, from: data) {
                    let photoList = PhotoList(photoListResponse: object)
                    self.didSearch(response: photoList)
                }
            }
        }
    }
}
#endif
