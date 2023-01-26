//
//  PostersListView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 03.12.2022.
//

import UIKit
import SkeletonView

protocol PostersListViewProtocol: AnyObject {
    func getImage(forSection section: Int, forIndex index: Int)
}

final class PostersListView: UIView {
    weak var delegate: PostersListViewProtocol?
    
    // MARK: - Private Properties
    private let cellIdentifier = "PostersListCell"
    private let headerIdentifier = "PostersListHeader"
    private let cellLineSpacing: CGFloat = 8
    
    private var collectionView: UICollectionView!
    
    private var postersListData: [PostersListViewModel]?
    
    init() {
        super.init(frame: .zero)
        
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - collectionView
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        addSubview(collectionView)
        collectionView.register(CarouselCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(PostersListCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.isSkeletonable = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
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
    
    func updateDataArray(_ data: [PostersListViewModel]) {
        postersListData = data
        updateSkeletonView()
        reloadData()
    }
    
    func updateData(_ data: PostersListViewModel, from index: Int) {
        postersListData?[index] = data
        reloadData()
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// MARK: - SkeletonView

extension PostersListView: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return cellIdentifier
    }
    
    private func updateSkeletonView() {
        DispatchQueue.main.async {
            if self.postersListData == nil,
                self.collectionView.sk.isSkeletonActive == false {
                self.collectionView.showAnimatedSkeleton()
            } else if self.collectionView.sk.isSkeletonActive == true {
                self.collectionView.hideSkeleton(reloadDataAfter: false, transition: .none)
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PostersListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: PostersListCollectionViewHeader.titleLableHeight)
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
        let index = indexPath.row
        header.titleLabel.text = postersListData?[index].headerString
        header.hideSkeleton(reloadDataAfter: false)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postersListData?[section].list.count ?? 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CarouselCollectionViewCell else {
            fatalError("Cell is doesn`t CarouselCollectionViewCell")
        }
        cell.titleLabel.text = nil
        cell.imageView.image = nil
        guard postersListData != nil else {
            if collectionView.sk.isSkeletonActive == false {
                collectionView.showAnimatedSkeleton()
            }
            return cell
        }
                
        let section = indexPath.section
        let index = indexPath.row
        cell.titleLabel.text = postersListData?[section].list[index].title
        guard let image = postersListData?[section].list[index].image, postersListData?[section].list[index].imageIsLoading == false else {
            postersListData?[section].list[index].imageIsLoading = true
            cell.imageView.showAnimatedSkeleton()
            delegate?.getImage(forSection: section, forIndex: index)
            return cell
        }
        if cell.imageView.sk.isSkeletonActive == true {
            cell.imageView.hideSkeleton(reloadDataAfter: false, transition: .none)
        }
        cell.imageView.image = image
        return cell
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
