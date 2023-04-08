//
//  PostersListView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 03.12.2022.
//

import UIKit
import SkeletonView

protocol PostersListViewProtocol: AnyObject {
    func cellClicked(at indexPath: IndexPath)
    
    func getData()
    func getImage(for indexPath: IndexPath)
}

final class PostersListView: UIView {
    weak var delegate: PostersListViewProtocol?
    
    // MARK: - Private Properties
    private let cellIdentifier = "PostersListCell"
    private let headerIdentifier = "PostersListHeader"
    private let cellLineSpacing: CGFloat = 8
    
    private var collectionView: UICollectionView!
    
    private var postersListData: [PostersListViewModel]? {
        didSet {
            postersListDataIsLoading = false
        }
    }
    private var postersListDataIsLoading: Bool = false
    
    init(withData data: [PostersListViewModel]? = nil) {
        super.init(frame: .zero)
        postersListData = data
        
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - collectionView
    private func configureCollectionView() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.sectionHeadersPinToVisibleBounds = true
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        addSubview(collectionView)
        collectionView.register(CarouselCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(PostersListCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.isSkeletonable = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        
        setCollectionViewConstraints()
    }
    
    private func setCollectionViewConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func getData() {
        postersListDataIsLoading = true
        delegate?.getData()
    }
    
    func updateData(_ data: [PostersListViewModel]) {
        postersListData = data
        toggleSkeletonView()
        reloadData()
    }
    
    func updateImage(_ image: UIImage?, for indexPath: IndexPath) {
        if image == nil {
            postersListData?[indexPath.section].postersList[indexPath.row].imageIsLoading = false
            return
        }
        postersListData?[indexPath.section].postersList[indexPath.row].image = image
        postersListData?[indexPath.section].postersList[indexPath.row].imageIsLoading = false
        DispatchQueue.main.async {
            // С анимацией при быстром скроле временно пропадает header
            UIView.performWithoutAnimation {
                self.collectionView.reconfigureItems(at: [indexPath])
            }
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func toggleSkeletonView() {
        DispatchQueue.main.async {
            if self.postersListData == nil,
                self.collectionView.sk.isSkeletonActive == false {
                self.collectionView.showAnimatedSkeleton()
            } else if self.collectionView.sk.isSkeletonActive == true {
                self.collectionView.hideSkeleton(reloadDataAfter: false)
            }
        }
    }
}

// MARK: - SkeletonView

extension PostersListView: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return cellIdentifier
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PostersListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if postersListData != nil, postersListData?[section].headerName == nil {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.width, height: PostersListCollectionViewHeader.titleLableHeight)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellLineSpacing, left: cellLineSpacing, bottom: cellLineSpacing, right: cellLineSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.bounds.width
        let multiplier: CGFloat = 500 / 350
        let itemWidth = (screenWidth / 2) - (cellLineSpacing * 3)
        return CGSize(width: itemWidth, height: itemWidth * multiplier + CarouselCollectionViewCell.stackSpacing + CarouselCollectionViewCell.titleLabelHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellLineSpacing
    }
}

// MARK: - UICollectionViewDataSource && UICollectionViewDelegate

extension PostersListView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return postersListData?.count ?? 3
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier, for: indexPath) as? PostersListCollectionViewHeader else {
            fatalError("HeaderView is doesn`t PostersListCollectionViewHeader")
        }
        guard postersListData != nil else {
            header.showAnimatedSkeleton()
            return header
        }
        let section = indexPath.section
        header.titleLabel.text = postersListData?[section].headerName
        header.hideSkeleton(reloadDataAfter: false)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postersListData?[section].postersList.count ?? 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CarouselCollectionViewCell else {
            fatalError("Cell is doesn`t CarouselCollectionViewCell")
        }
        guard postersListData != nil else {
            if collectionView.sk.isSkeletonActive == false {
                collectionView.showAnimatedSkeleton()
                getData()
            }
            return cell
        }
        
        let data = postersListData?[indexPath.section].postersList[indexPath.row]
        cell.titleLabel.text = data?.name
        cell.imageView.image = nil
        
        guard let image = data?.image else {
            if data?.imageIsLoading == false && NetworkMonitor.shared.isConnected == true {
                postersListData?[indexPath.section].postersList[indexPath.row].imageIsLoading = true
                delegate?.getImage(for: indexPath)
            }
            if cell.imageView.sk.isSkeletonActive == false {
                cell.imageView.showAnimatedSkeleton()
            }
            return cell
        }

        cell.imageView.image = image
        if cell.imageView.sk.isSkeletonActive == true {
            cell.imageView.hideSkeleton(reloadDataAfter: false)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.cellClicked(at: indexPath)
    }
    
}

// MARK: - UICollectionViewDataSourcePrefetching
extension PostersListView: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let data = postersListData?[indexPath.section].postersList[indexPath.row]
            
            if data?.image == nil && data?.imageIsLoading == false && NetworkMonitor.shared.isConnected == true {
                postersListData?[indexPath.section].postersList[indexPath.row].imageIsLoading = true
                delegate?.getImage(for: indexPath)
            }
        }
    }
}

#if DEBUG

// MARK: - Live Preview In UIKit
import SwiftUI
struct View_Previews: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            // View()
            PostersListView()
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
    }
}

#endif
