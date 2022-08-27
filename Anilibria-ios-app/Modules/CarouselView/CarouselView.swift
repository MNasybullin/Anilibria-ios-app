//
//  CarouselView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 24.08.2022.
//

import UIKit

final class CarouselView: UIView {
    private let cellIdentifier = "CarouselCell"
    
    lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [hTitleStack, carouselView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5
        addSubview(stack)
        return stack
    }()
    
    lazy var hTitleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, titleButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        return stack
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.text = "TitleLabel"
        
        return label
    }()
    
    lazy var titleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.setTitle("Все", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    lazy var carouselView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumLineSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CarouselCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        carouselView.delegate = self
        carouselView.dataSource = self
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: topAnchor),
            vStack.leftAnchor.constraint(equalTo: leftAnchor),
            vStack.rightAnchor.constraint(equalTo: rightAnchor),
            vStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            hTitleStack.heightAnchor.constraint(equalToConstant: 32),
            
            titleLabel.leftAnchor.constraint(equalTo: hTitleStack.leftAnchor, constant: 16),
            
            titleButton.widthAnchor.constraint(equalToConstant: 64),
            titleButton.rightAnchor.constraint(equalTo: vStack.rightAnchor, constant: -16),
           
            carouselView.leftAnchor.constraint(equalTo: vStack.leftAnchor, constant: 0)
        ])
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CarouselView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.height - 10)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        guard let layout = carouselView.collectionViewLayout as? UICollectionViewFlowLayout else {
//            fatalError()
//        }
//        let cellWidth = layout.itemSize.width
//        let screenWidth = UIScreen.main.bounds.width / 2
//        let res = screenWidth - cellWidth
//
//        return UIEdgeInsets(top: 0, left: res, bottom: 0, right: 0)
//    }
}

// MARK: - UICollectionViewDataSource

extension CarouselView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CarouselCollectionViewCell else {
            fatalError("Cell is doesn`t CarouselCollectionViewCell")
        }
        cell.titleLabel.text = "Test Title Label"
//        cell.titleLabel.isHidden = true
        return cell
    }
}

// MARK: - UIScrollViewDelegate

//extension CarouselView: UIScrollViewDelegate {
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        guard let layout = carouselView.collectionViewLayout as? UICollectionViewFlowLayout else {
//            return
//        }
//        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
//
//        var offset = targetContentOffset.pointee
//        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
//        let roundedIndex = round(index)
//
//        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
//
//        targetContentOffset.pointee = offset
//    }
//}

#if DEBUG

// MARK: - Live Preview In UIKit
import SwiftUI
struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            CarouselView()
        }
        .frame(width: 390, height: 450, alignment: .center)
        .previewDevice("iPhone 12")
    }
}

#endif
