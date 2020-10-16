//
//  PhotoListViewController.swift
//  TestUICollectionViewCompositionalLayout
//
//  Created by Kosuke Matsuda on 2020/10/13.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import UIKit
import Library

final class PhotoListViewController: UIViewController {

    typealias Section = PhotoListViewData.Section
    typealias Photo = PhotoListViewData.Photo
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Photo>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Photo>

    // UIs
    @IBOutlet weak var collectionView: UICollectionView!
    private lazy var searchController: UISearchController = createSearchController()

    // property
    private lazy var presenter: PhotoListPresenter = createPresenter()
    private lazy var dataSource: DataSource = createDataSource()


    // Life cycles

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigation()
        setupSearchController()
        setupCollectionView()
        prepareSnapshot()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        #if DEBUG
//        presenter.loadData()
        #endif
    }
}


// MARK: - private

extension PhotoListViewController {
    private func setupNavigation() {
        title = "Photo List"
    }

    private func setupSearchController() {
        navigationItem.searchController = searchController
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView.registerNib(ImageCollectionViewCell.self)
        collectionView.registerNib(LoadingCollectionViewCell.self)
        collectionView.registerNib(LoadingReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
    }

    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            /*
            // loading
            if case .loading = Section(rawValue: sectionIndex)! {
                let item: NSCollectionLayoutItem = {
                    let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                    let item = NSCollectionLayoutItem(layoutSize: size)
                    return item
                }()
                let group: NSCollectionLayoutGroup = {
                    let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
                    return group
                }()
                let section: NSCollectionLayoutSection = {
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
                    return section
                }()
                return section
            }
             */

            // photoList
            let twoItem: NSCollectionLayoutItem = {
                let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: size)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
                return item
            }()
            let twoItemGroup: NSCollectionLayoutGroup = {
                let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.25))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: twoItem, count: 2)
                group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                return group
            }()
            let oneItem: NSCollectionLayoutItem = {
                let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
                let item = NSCollectionLayoutItem(layoutSize: size)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
                return item
            }()
            let group: NSCollectionLayoutGroup = {
                let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(2))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [twoItemGroup, twoItemGroup, oneItem])
                return group
            }()
            let section: NSCollectionLayoutSection = {
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
                return section
            }()
            let footer: NSCollectionLayoutBoundarySupplementaryItem = {
                let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
                let item = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: size,
                                                                       elementKind: UICollectionView.elementKindSectionFooter,
                                                                       alignment: .bottom)
                return item
            }()
            section.boundarySupplementaryItems = [footer]
            return section
        }
        return layout
    }

    private func createSearchController() -> UISearchController {
        let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Photos"
        return searchController
    }

    private func createPresenter() -> PhotoListPresenter {
        let repository = PhotoListRepositoryImpl()
        let usecase = PhotoListUseCaseImpl(respository: repository)
        let presenter = PhotoListPresenter(useCase: usecase)
        presenter.output = self
        return presenter
    }

    private func createDataSource() -> DataSource {
        let source = DataSource(collectionView: collectionView) { (collectionView, indexPath, model) -> UICollectionViewCell? in
            /*
            // loading
            if case .loading = Section(rawValue: indexPath.section)! {
                let cell = collectionView.dequeueReusableCell(LoadingCollectionViewCell.self, for: indexPath)
                return cell
            }
             */

            // photoList
            let cell = collectionView.dequeueReusableCell(ImageCollectionViewCell.self, for: indexPath)
            return cell
        }
        source.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionFooter else { return nil }
            let view = collectionView.dequeueReusableSupplementaryView(LoadingReusableView.self, ofKind: kind, for: indexPath)
            return view
        }
        return source
    }

    private func prepareSnapshot() {
        var snapshot = Snapshot()
        // photoList
        snapshot.appendSections([.photoList])
        snapshot.appendItems([], toSection: .photoList)

        /*
        // loading
        snapshot.appendSections([.loading])
        let loading = PhotoListPhoto(id: "-1", imageURL: URL(string: "https://example.com")!) // dummy
        snapshot.appendItems([loading], toSection: .loading)
         */
        dataSource.apply(snapshot)
    }

    private func applySnapshot(items: [Photo], animatingDifferences: Bool = true) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(items, toSection: .photoList)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}


// MARK: - PhotoListPresenterOutput

extension PhotoListViewController: PhotoListPresenterOutput {
    func photoListPresenter(photoListPresenter: PhotoListPresenter, searchPhotoList: [PhotoListPhoto]) {
        applySnapshot(items: searchPhotoList)
    }

    func photoListPresenter(photoListPresenter: PhotoListPresenter, searchError: Error) {
        print("error >>>>", searchError)
    }
}


// MARK: - UICollectionViewDataSource

//extension PhotoListViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return presenter.photoList.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(ImageCollectionViewCell.self, for: indexPath)
//        return cell
//    }
//}


// MARK: - UICollectionViewDelegate

extension PhotoListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        /*
        // if loading
        if case .loading = Section(rawValue: indexPath.section)! {
            let itemCount = dataSource.snapshot().numberOfItems(inSection: .photoList)
            guard itemCount != 0 else { return }
            if let loadingCell = cell as? LoadingCollectionViewCell {
                loadingCell.startAnimating()
                presenter.paging()
            }
            return
        }
         */

        // photoList
        guard let cell = cell as? ImageCollectionViewCell else { return }
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        cell.fetch(url: item.imageURL)
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ImageCollectionViewCell else { return }
        cell.stopFetch()
    }

    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard elementKind == UICollectionView.elementKindSectionFooter else { return }
        guard let loading = view as? LoadingReusableView else { return }

        let itemCount = dataSource.snapshot().numberOfItems(inSection: .photoList)
        if itemCount == 0 {
            loading.stopAnimating()
            loading.isHidden = true
        } else {
            loading.startAnimating()
            loading.isHidden = false
            presenter.paging()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        guard elementKind == UICollectionView.elementKindSectionFooter else { return }
        guard let loading = view as? LoadingReusableView else { return }
        loading.stopAnimating()
    }
}


// MARK: - UISearchBarDelegate

extension PhotoListViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        #if DEBUG
        print(#function, ":", searchBar.text as Any)
        #endif
        guard let text = searchBar.text, !text.isEmpty else { return }
        prepareSnapshot()
        presenter.get()
//        searchController?.isActive = false
    }
}
