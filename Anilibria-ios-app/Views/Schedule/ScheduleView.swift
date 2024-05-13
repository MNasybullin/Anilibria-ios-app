//
//  ScheduleView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 25.10.2023.
//

import UIKit
import SkeletonView

protocol ScheduleViewDelegate: AnyObject {
    func refreshButtonDidTapped()
}

final class ScheduleView: UIView {
    enum Status {
        case loading
        case normal
        case error(Error)
        
        static func == (lhs: Status, rhs: Status) -> Bool {
            switch (lhs, rhs) {
                case (.normal, .normal),
                    (.loading, .loading),
                    (.error, .error):
                    return true
                default:
                    return false
            }
        }
        
        static func != (lhs: Status, rhs: Status) -> Bool {
            return !(lhs == rhs)
        }
    }
    
    private lazy var layout = ScheduleCollectionViewLayout()
    private (set) lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout.createLayout())
    
    private lazy var errorView: StatusAlertView = {
        let statusView = StatusAlertView()
        let image = UIImage(systemName: Strings.StatusAlertView.Error.image)?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        statusView.setImage(image)
        statusView.setTitle(text: Strings.StatusAlertView.Error.title)
        statusView.setActionButton(title: Strings.StatusAlertView.Error.refreshButtonTitle, for: .normal)
        statusView.setActionButton(action: UIAction(handler: { [weak self] _ in
            self?.delegate?.refreshButtonDidTapped()
        }), for: .touchUpInside)
        return statusView
    }()
    
    weak var delegate: ScheduleViewDelegate?
    
    init(delegate: ScheduleViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        
        configureView()
        configureCollectionView()
        configureLayout()
        updateView(withStatus: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension ScheduleView {
    func configureView() {
        backgroundColor = .systemBackground
    }
    
    func configureCollectionView() {
        collectionView.register(
            PosterCollectionViewCell.self,
            forCellWithReuseIdentifier: PosterCollectionViewCell.reuseIdentifier)
        collectionView.register(
            ScheduleHeaderSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ScheduleHeaderSupplementaryView.reuseIdentifier)
        
        collectionView.isSkeletonable = true
    }
    
    func configureLayout() {
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        addSubview(errorView)
        errorView.setupFullScreenConstraints(to: self)
    }
}

// MARK: - Internal methods

extension ScheduleView {
    func updateView(withStatus status: Status) {
        switch status {
            case .loading:
                errorView.isHidden = true
                collectionView.isHidden = false
                collectionView.showAnimatedSkeleton()
            case .normal:
                errorView.isHidden = true
                collectionView.isHidden = false
                collectionView.hideSkeleton(reloadDataAfter: false)
            case .error(let error):
                errorView.isHidden = false
                collectionView.isHidden = true
                errorView.setMessage(text: error.localizedDescription)
        }
    }
}
