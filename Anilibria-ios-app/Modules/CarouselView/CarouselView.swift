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
    
    private let cellLineSpacing: CGFloat = 16
    private let vStackViewSpacing: CGFloat = 10
    private let hTitleStackViewHeight: CGFloat = 32
        
    private var vStackView = UIStackView()
    private var hTitleStackView = UIStackView()
    private var titleLabel = UILabel()
    private var titleButton = UIButton()
    private var carouselView: UICollectionView!
    
    let typeView: CarouselViewType
    
    init(title: String, buttonTitle: String, type: CarouselViewType) {
        typeView = type
        super.init(frame: .zero)
        
        setupViewAccording(withType: type)
        
        configureVStackView()
        configureHTitleStackView()
        configureTitleLabel(withTitle: title)
        configureTitleButton(withTitle: buttonTitle)
        configureCarouselView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewAccording(withType type: CarouselViewType) {
        let screenWidth = UIScreen.main.bounds.width
        let multiplier: CGFloat = 350 / 500
        switch typeView {
            case .largeVerticalPoster:
                cellWidth = screenWidth - (cellLineSpacing * 2) - (screenWidth / 9)
            case .standartVerticalPoster:
                cellWidth = screenWidth - (cellLineSpacing * 2) - (screenWidth / 2)
        }
        cellHeight = (cellWidth / multiplier) + CarouselCollectionViewCell.stackSpacing + CarouselCollectionViewCell.titleLabelHeight
        let height = cellHeight + hTitleStackViewHeight + vStackViewSpacing
        self.frame = CGRect(x: 0, y: 0, width: screenWidth, height: height)
    }
    
    // MARK: - vStackView
    func configureVStackView() {
        addSubview(vStackView)
        vStackView.axis = .vertical
        vStackView.spacing = vStackViewSpacing
        setVStackViewConstraints()
    }
    
    func setVStackViewConstraints() {
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        vStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        vStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        vStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        vStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    // MARK: - hTtitleStackView
    func configureHTitleStackView() {
        vStackView.addArrangedSubview(hTitleStackView)
        hTitleStackView.axis = .horizontal
        setHTitleStackViewConstraints()
    }
    
    func setHTitleStackViewConstraints() {
        hTitleStackView.translatesAutoresizingMaskIntoConstraints = false
        hTitleStackView.heightAnchor.constraint(equalToConstant: hTitleStackViewHeight).isActive = true
    }
    
    // MARK: - titleLabel
    func configureTitleLabel(withTitle title: String) {
        hTitleStackView.addArrangedSubview(titleLabel)
        titleLabel.text = title
        titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        setTitleLabelConstraints()
    }
    
    func setTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: hTitleStackView.leadingAnchor, constant: cellLineSpacing).isActive = true
    }
    
    // MARK: - titleButton
    func configureTitleButton(withTitle title: String) {
        hTitleStackView.addArrangedSubview(titleButton)
        titleButton.setTitle(title, for: .normal)
        titleButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        titleButton.setTitleColor(UIColor.label, for: .normal)
        setTitleButtonConstraints()
    }
    
    func setTitleButtonConstraints() {
        titleButton.translatesAutoresizingMaskIntoConstraints = false
        titleButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        titleButton.trailingAnchor.constraint(equalTo: vStackView.trailingAnchor, constant: -cellLineSpacing).isActive = true
    }
    
    // MARK: - carouselView
    func configureCarouselView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: cellLineSpacing, bottom: 0, right: cellLineSpacing)
        layout.minimumLineSpacing = cellLineSpacing
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        carouselView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vStackView.addArrangedSubview(carouselView)
        carouselView.register(CarouselCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        carouselView.showsHorizontalScrollIndicator = false
        
        carouselView.delegate = self
        carouselView.dataSource = self
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CarouselView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
        cell.imageView.image = UIImage(asset: Asset.Assets.defaultTitleImage)
//        cell.titleLabel.isHidden = true
        return cell
    }
}

// MARK: - UIScrollViewDelegate

extension CarouselView: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard typeView == .largeVerticalPoster, let layout = carouselView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        let additionalSpacing = (UIScreen.main.bounds.width - layout.itemSize.width - (layout.minimumLineSpacing * 2)) / 2
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left - additionalSpacing, y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}

#if DEBUG

// MARK: - Live Preview In UIKit
import SwiftUI
struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            CarouselView(title: "Title", buttonTitle: "All", type: .largeVerticalPoster)
        }
        .frame(width: 390, height: 600, alignment: .center)
    }
}

#endif
