//
//  CarouselView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 24.08.2022.
//

import UIKit
import SkeletonView

protocol CarouselViewProtocol: AnyObject {
    func titleButtonAction(sender: UIButton)
    func cellClicked()
    
//    func getData(forIndex index: Int, forCarouselView carouselView: CarouselView)
    
    func getImage(forIndex index: Int, forCarouselView carouselView: CarouselView)
}

/// - Для корректного отображения SkeletonView, необходимо в viewDidAppear вызвать reloadData() данного CarouselView
final class CarouselView: UIView {
    weak var delegate: CarouselViewProtocol?
    
    // MARK: - Private Properties
    private let cellIdentifier = "CarouselCell"
    private var cellSize: CGSize!
    private var imageSize: CGSize!
    
    private let cellLineSpacing: CGFloat = 16
    
    private var vContentStackView = UIStackView()
    private var hTitleAndButtonStackView = UIStackView()
    private var titleLabel = UILabel()
    private var titleButton = UIButton()
    private var carouselView: UICollectionView!
    
    private var cellFocusAnimation: Bool!
    
    var carouselData: [CarouselViewModel]?
    
    /// - Parameters:
    ///     - cellFocusAnimation: Анимация перелистывания ячеек (ячейка всегда в центре).
    init(withTitle title: String, buttonTitle: String, imageSize: CGSize, cellFocusAnimation: Bool) {
        super.init(frame: .zero)
        self.imageSize = imageSize
        self.cellSize = CGSize(width: imageSize.width, height: imageSize.height + CarouselCollectionViewCell.stackSpacing + CarouselCollectionViewCell.titleLabelHeight)
        self.cellFocusAnimation = cellFocusAnimation

        configureVContentStackView()
        configureHTitleAndButtonStackView(withTitle: title, buttonTitle: buttonTitle)
        configureCarouselView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - vContentStackView
    private func configureVContentStackView() {
        self.addSubview(vContentStackView)
        vContentStackView.axis = .vertical
        vContentStackView.spacing = 6
//        vContentStackView.backgroundColor = .red //
        setVContentStackViewConstraints()
    }
    
    private func setVContentStackViewConstraints() {
        vContentStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vContentStackView.topAnchor.constraint(equalTo: self.topAnchor),
            vContentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            vContentStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            vContentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    // MARK: - hTitleAndButtonStackView
    private func configureHTitleAndButtonStackView(withTitle title: String, buttonTitle: String) {
        vContentStackView.addArrangedSubview(hTitleAndButtonStackView)
        hTitleAndButtonStackView.axis = .horizontal
        hTitleAndButtonStackView.spacing = 6
//        hTitleAndButtonStackView.alignment = .center
        
        configureTitleLabel(withTitle: title)
        configureTitleButton(withTitle: buttonTitle)
        
        setHTitleAndButtonStackViewConstraints()
    }
    
    private func setHTitleAndButtonStackViewConstraints() {
        hTitleAndButtonStackView.widthAnchor.constraint(equalTo: vContentStackView.widthAnchor).isActive = true
    }
    
    // MARK: - titleLabel
    private func configureTitleLabel(withTitle title: String) {
        hTitleAndButtonStackView.addArrangedSubview(titleLabel)
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
//        titleLabel.backgroundColor = .cyan //
        setTitleLabelConstraints()
    }
    
    private func setTitleLabelConstraints() {
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: titleLabel.font.lineHeight).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: vContentStackView.leadingAnchor, constant: 16).isActive = true
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    // MARK: - titleButton
    private func configureTitleButton(withTitle title: String) {
        hTitleAndButtonStackView.addArrangedSubview(titleButton)
        titleButton.setTitle(title, for: .normal)
        titleButton.setTitleColor(UIColor.label, for: .normal)
        titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
//        titleButton.backgroundColor = .brown //
        titleButton.addTarget(self, action: #selector(titleButtonAction(sender:)), for: .touchUpInside)
        setTitleButtonConstraints()
    }
    
    private func setTitleButtonConstraints() {
        guard let lineHeight = titleButton.titleLabel?.font.lineHeight else {
            return
        }
        titleButton.heightAnchor.constraint(greaterThanOrEqualToConstant: lineHeight).isActive = true
        titleButton.trailingAnchor.constraint(equalTo: vContentStackView.trailingAnchor, constant: -16).isActive = true
        titleButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    @objc private func titleButtonAction(sender: UIButton) {
        // отключать кнопку если данные еще не загрузились!
        delegate?.titleButtonAction(sender: sender)
    }
    
    // MARK: - carouselView
    private func configureCarouselView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: cellLineSpacing, bottom: 0, right: cellLineSpacing)
        layout.minimumLineSpacing = cellLineSpacing
        layout.itemSize = CGSize(width: cellSize.width, height: cellSize.height)
        
        carouselView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vContentStackView.addArrangedSubview(carouselView)
        carouselView.register(CarouselCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        carouselView.showsHorizontalScrollIndicator = false
        
        setCarouselViewConstraints()
        
        carouselView.delegate = self
        carouselView.dataSource = self
    }
    
    private func setCarouselViewConstraints() {
        carouselView.heightAnchor.constraint(greaterThanOrEqualToConstant: cellSize.height).isActive = true
    }
    
    func deleteData() {
        carouselData = nil
        carouselView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
        reloadData()
    }
    
    func updateData(_ data: [CarouselViewModel]) {
        carouselData = data
        reloadData()
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.carouselView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

//extension CarouselView: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: cellSize.width, height: cellSize.height)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return cellLineSpacing
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: cellLineSpacing, bottom: 0, right: cellLineSpacing)
//    }
//}

// MARK: - UICollectionViewDataSource && UICollectionViewDelegate

extension CarouselView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carouselData?.count ?? 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CarouselCollectionViewCell else {
            fatalError("Cell is doesn`t CarouselCollectionViewCell")
        }
        cell.titleLabel.text = nil
        cell.imageView.image = nil
        guard carouselData != nil else {
            if cell.sk.isSkeletonActive == false {
                cell.showAnimatedSkeleton()
            }
            return cell
        }

        let index = indexPath.row
        cell.titleLabel.text = carouselData?[index].title
        if cell.titleLabel.sk.isSkeletonActive == true {
            cell.titleLabel.hideSkeleton(reloadDataAfter: false, transition: .none)
        }
        guard let image = carouselData?[index].image, carouselData?[index].imageIsLoading == false else {
            carouselData?[index].imageIsLoading = true
            delegate?.getImage(forIndex: index, forCarouselView: self)
            return cell
        }
        cell.imageView.image = image
        if cell.imageView.sk.isSkeletonActive == true {
            cell.imageView.hideSkeleton(reloadDataAfter: false, transition: .none)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.cellClicked()
    }
    
}

// MARK: - UIScrollViewDelegate

extension CarouselView: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = carouselView.collectionViewLayout as? UICollectionViewFlowLayout, cellFocusAnimation == true else {
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
            CarouselView(withTitle: "Title", buttonTitle: "All", imageSize: CGSize(width: 350, height: 500), cellFocusAnimation: true)
        }
        .frame(width: 390, height: 600, alignment: .center)
    }
}

#endif
