//
//  InfiniteCollectionView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 03.12.2022.
//

import UIKit

protocol InfiniteCollectionViewProtocol: AnyObject {
    
}

final class InfiniteCollectionView: UIView {
    weak var delegate: InfiniteCollectionViewProtocol?
    
    // MARK: - Private Properties
    private let cellIdentifier = "CarouselCell"
    private let headerIdentifier = "InfiniteHeader"
    private let cellLineSpacing: CGFloat = 8
    
    private var collectionView: UICollectionView!
    
    var data: InfiniteCollectionViewModel? {
        didSet {
            reloadData()
        }
    }
    
    override init(frame: CGRect) {
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
        collectionView.register(InfiniteCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
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
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension InfiniteCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: InfiniteCollectionViewHeader.titleLableHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellLineSpacing, left: 0, bottom: cellLineSpacing, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.bounds.width
        let multiplier: CGFloat = 500 / 350
        let itemWidth = (screenWidth / 2) - cellLineSpacing
        return CGSize(width: itemWidth, height: itemWidth * multiplier + CarouselCollectionViewCell.stackSpacing + CarouselCollectionViewCell.titleLableHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellLineSpacing
    }
}

// MARK: - UICollectionViewDataSource && UICollectionViewDelegate

extension InfiniteCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier, for: indexPath) as? InfiniteCollectionViewHeader else {
            fatalError("HeaderView is doesn`t InfiniteCollectionViewHeader")
        }
        header.titleLabel.text = "Header title label"
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CarouselCollectionViewCell else {
            fatalError("Cell is doesn`t CarouselCollectionViewCell")
        }
        cell.titleLabel.text = "Infinite Collection View as"
        cell.imageView.image = UIImage(asset: Asset.Assets.defaultTitleImage)
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
            InfiniteCollectionView()
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
    }
}

#endif
