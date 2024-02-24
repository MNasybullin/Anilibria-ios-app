//
//  NotificationBannerView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 24.02.2024.
//

import UIKit

final class NotificationBannerView: UIView {
    enum BannerType {
        case success, info, warning, error
        
        var tintColor: UIColor {
            switch self {
                case .success:
                    UIColor.systemGreen
                case .info:
                    UIColor.systemTeal
                case .warning:
                    UIColor.systemOrange
                case .error:
                    UIColor.systemRed
            }
        }
    }
    
    struct BannerData {
        var title: String
        var detail: String
        var type: BannerType
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .white
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    
    private var data: BannerData
    private var gestureIsBegan = false
    
    init(data: BannerData) {
        self.data = data
        super.init(frame: .zero)
        
        setupView()
        setupGestureRecognizer()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension NotificationBannerView {
    func setupView() {
        titleLabel.text = data.title
        detailLabel.text = data.detail
        backgroundColor = data.type.tintColor
        
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    func setupGestureRecognizer() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        gesture.maximumNumberOfTouches = 1
        addGestureRecognizer(gesture)
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view)
        let velocity = gestureRecognizer.velocity(in: gestureRecognizer.view)
        var progress = -(translation.y / self.bounds.height)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
            case .began:
                gestureIsBegan = true
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
                    self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                }
            case .changed:
                guard gestureIsBegan == true else { break }
                var translationY = translation.y
                translationY = translationY < 0 ? translationY : translationY / 2
                
                transform = CGAffineTransform(translationX: 0, y: translationY).scaledBy(x: 0.95, y: 0.95)
            case .ended:
                gestureIsBegan = false
                if progress > 0.6 || (velocity.y < -300 && progress > 0.2) {
                    hideBanner()
                } else {
                    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
                        self.transform = .identity
                    }
                }
            default:
                break
        }
    }
    
    func setupLayout() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(detailLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    func hideBanner() {
        UIView.animate(withDuration: 0.25) {
            self.transform = self.transform.translatedBy(x: 0, y: -100)
            self.alpha = 0
        } completion: { [weak self] _ in
            self?.removeFromSuperview()
        }
    }
}

// MARK: - Internal methods

extension NotificationBannerView {
    func show() {
        let rootVC = MainNavigator.shared.rootViewController
        let rootView = rootVC.customView
        
        rootView.addSubview(self)
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.topAnchor),
            self.leadingAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.trailingAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        transform = CGAffineTransform(translationX: 0, y: -250)
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut]) {
            self.transform = .identity
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) { [weak self] in
                self?.hideBanner()
            }
        }
    }
}
