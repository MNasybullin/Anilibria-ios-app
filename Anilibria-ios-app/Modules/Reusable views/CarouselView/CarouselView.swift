//
//  CarouselView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 24.08.2022.
//

import UIKit

protocol CarouselViewProtocol: AnyObject {
    func titleButtonAction(sender: UIButton)
    func cellClicked()
    func getImage(fromData data: [GetTitleModel]?, index: Int)
}

final class CarouselView: UIView {
    
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
    
    var cellFocusAnimation: Bool!
    
    var data: [GetTitleModel]? {
        didSet {
            DispatchQueue.main.async {
                self.carouselView.reloadData()
            }
        }
    }
    
    weak var delegate: CarouselViewProtocol?
        
    init(withTitle title: String, buttonTitle: String, imageSize: CGSize, cellFocusAnimation: Bool) {
        super.init(frame: .zero)
        self.imageSize = imageSize
        cellSize = getCellSize()
        self.cellFocusAnimation = cellFocusAnimation

        configureVContentStackView()
        configureHTitleAndButtonStackView(withTitle: title, buttonTitle: buttonTitle)
        configureCarouselView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getCellSize() -> CGSize {
        let cell = CarouselCollectionViewCell()
        let titleLabelHeight = cell.titleLabel.font.lineHeight * CGFloat(cell.titleLabel.numberOfLines)
        return CGSize(width: imageSize.width, height: imageSize.height + titleLabelHeight + CarouselCollectionViewCell.stackSpacing)
    }
    
    // MARK: - vContentStackView
    func configureVContentStackView() {
        self.addSubview(vContentStackView)
        vContentStackView.axis = .vertical
        vContentStackView.spacing = 6
//        vContentStackView.backgroundColor = .red //
        setVContentStackViewConstraints()
    }
    
    func setVContentStackViewConstraints() {
        vContentStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vContentStackView.topAnchor.constraint(equalTo: self.topAnchor),
            vContentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            vContentStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            vContentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    // MARK: - hTitleAndButtonStackView
    func configureHTitleAndButtonStackView(withTitle title: String, buttonTitle: String) {
        vContentStackView.addArrangedSubview(hTitleAndButtonStackView)
        hTitleAndButtonStackView.axis = .horizontal
        hTitleAndButtonStackView.spacing = 6
//        hTitleAndButtonStackView.alignment = .center
        
        configureTitleLabel(withTitle: title)
        configureTitleButton(withTitle: buttonTitle)
        
        setHTitleAndButtonStackViewConstraints()
    }
    
    func setHTitleAndButtonStackViewConstraints() {
        hTitleAndButtonStackView.widthAnchor.constraint(equalTo: vContentStackView.widthAnchor).isActive = true
    }
    
    // MARK: - titleLabel
    func configureTitleLabel(withTitle title: String) {
        hTitleAndButtonStackView.addArrangedSubview(titleLabel)
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
//        titleLabel.backgroundColor = .cyan //
        setTitleLabelConstraints()
    }
    
    func setTitleLabelConstraints() {
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: titleLabel.font.lineHeight).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: vContentStackView.leadingAnchor, constant: 16).isActive = true
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    // MARK: - titleButton
    func configureTitleButton(withTitle title: String) {
        hTitleAndButtonStackView.addArrangedSubview(titleButton)
        titleButton.setTitle(title, for: .normal)
        titleButton.setTitleColor(UIColor.label, for: .normal)
        titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
//        titleButton.backgroundColor = .brown //
        titleButton.addTarget(self, action: #selector(titleButtonAction(sender:)), for: .touchUpInside)
        setTitleButtonConstraints()
    }
    
    func setTitleButtonConstraints() {
        guard let lineHeight = titleButton.titleLabel?.font.lineHeight else {
            return
        }
        titleButton.heightAnchor.constraint(greaterThanOrEqualToConstant: lineHeight).isActive = true
        titleButton.trailingAnchor.constraint(equalTo: vContentStackView.trailingAnchor, constant: -16).isActive = true
        titleButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    @objc func titleButtonAction(sender: UIButton) {
        delegate?.titleButtonAction(sender: sender)
    }
    
    // MARK: - carouselView
    func configureCarouselView() {
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
    
    func setCarouselViewConstraints() {
        carouselView.heightAnchor.constraint(greaterThanOrEqualToConstant: cellSize.height).isActive = true
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CarouselView: UICollectionViewDelegateFlowLayout {
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
}

// MARK: - UICollectionViewDataSource

extension CarouselView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CarouselCollectionViewCell else {
            fatalError("Cell is doesn`t CarouselCollectionViewCell")
        }
        let index = indexPath.row
        cell.titleLabel.text = data?[index].names.ru ?? ""
        guard let imageData = data?[index].posters.original.image else {
            delegate?.getImage(fromData: data, index: index) // Наверное так не правильно
            cell.imageView.image = UIImage(asset: Asset.Assets.defaultTitleImage)
            return cell
        }
        let image = UIImage(data: imageData)
        cell.imageView.image = image
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