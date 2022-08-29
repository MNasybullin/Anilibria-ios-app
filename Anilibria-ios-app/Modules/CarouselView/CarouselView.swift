//
//  CarouselView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 24.08.2022.
//

import UIKit

final class CarouselView: UIView {
    // MARK: - Private Properties
    private let cellIdentifier = "CarouselCell"
    private var cellWidth: CGFloat!
    private var cellHeight: CGFloat!
    
    private let leftInset: CGFloat = 16
    private let rightInset: CGFloat = 16
    
    private let hTitleStackViewHeight: CGFloat = 32
    
    let typeView: CarouselViewType
    
    lazy var vStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [hTitleStackView, carouselView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5
        addSubview(stack)
        return stack
    }()
    
    lazy var hTitleStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, titleButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        return stack
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    
    var titleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    lazy var carouselView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        switch typeView {
            case .largeVerticalPoster:
                layout.minimumLineSpacing = 25
            case .standartVerticalPoster:
                layout.minimumLineSpacing = 15
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CarouselCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    init(title: String, buttonTitle: String, type: CarouselViewType) {
        typeView = type
        super.init(frame: .zero)
        
        setupViewAccording(withType: type)
        titleLabel.text = title
        titleButton.setTitle(buttonTitle, for: .normal)
        
        carouselView.delegate = self
        carouselView.dataSource = self
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewAccording(withType type: CarouselViewType) {
        let screenWidth = UIScreen.main.bounds.width
        let multiplier: CGFloat = 350 / 500
        switch typeView {
            case .largeVerticalPoster:
                cellWidth = screenWidth - (leftInset * 2) - (screenWidth / 9)
            case .standartVerticalPoster:
                cellWidth = screenWidth - (leftInset * 2) - (screenWidth / 2)
        }
        cellHeight = (cellWidth / multiplier) + CarouselCollectionViewCell.stackSpacing + CarouselCollectionViewCell.titleLabelHeight
        let height = cellHeight + hTitleStackViewHeight
        self.frame = CGRect(x: 0, y: 0, width: screenWidth, height: height)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            vStackView.topAnchor.constraint(equalTo: topAnchor),
            vStackView.leftAnchor.constraint(equalTo: leftAnchor),
            vStackView.rightAnchor.constraint(equalTo: rightAnchor),
            vStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            hTitleStackView.heightAnchor.constraint(equalToConstant: hTitleStackViewHeight),
            
            titleLabel.leftAnchor.constraint(equalTo: hTitleStackView.leftAnchor, constant: leftInset),
            
            titleButton.widthAnchor.constraint(equalToConstant: 64),
            titleButton.rightAnchor.constraint(equalTo: vStackView.rightAnchor, constant: -rightInset)
        ])
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CarouselView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width: CGFloat
//        let screenWidth = collectionView.frame.width
//        let multiplier: CGFloat = 350 / 500
//        switch typeView {
//            case .largeVerticalPoster:
//                width = screenWidth - (leftInset * 2) - (screenWidth / 9)
//            case .standartVerticalPoster:
//                width = screenWidth - (leftInset * 2) - (screenWidth / 2)
//        }
//        let height = (width / multiplier) + CarouselCollectionViewCell.stackSpacing + CarouselCollectionViewCell.titleLabelHeight
        return CGSize(width: cellWidth, height: cellHeight)
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
        cell.titleLabel.text = "Сквозь слёзы я притворяюсь кошкой"
//        cell.titleLabel.isHidden = true
        return cell
    }
}

// MARK: - UIScrollViewDelegate

//extension CarouselView: UIScrollViewDelegate {
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        guard typeView == .largeVerticalPoster, let layout = carouselView.collectionViewLayout as? UICollectionViewFlowLayout else {
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
            CarouselView(title: "Title", buttonTitle: "All", type: .largeVerticalPoster)
        }
        .frame(width: 390, height: 600, alignment: .center)
        .previewDevice("iPhone 12")
    }
}

#endif
