//
//  BottomOverlayView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 12.11.2023.
//

import UIKit

protocol BottomOverlayViewDelegate: AnyObject {
    func seriesButtonDidTapped()
}

final class BottomOverlayView: UIView {
    private enum Constants {
        static let labelFont: UIFont = UIFont.systemFont(ofSize: 15)
        static let thumbImageSize: CGSize = CGSize(width: 20, height: 20)
        static let seriesImagePadding: CGFloat = 8
        static let timeLabelPlaceholder: String = "--:--"
        static let topConstant: CGFloat = 8
    }
    
    weak var delegate: BottomOverlayViewDelegate?
    
    private lazy var seriesButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "rectangle.fill.on.rectangle.fill")
        config.baseForegroundColor = .white
        config.title = "Серии"
        config.buttonSize = .medium
        config.imagePadding = Constants.seriesImagePadding
        
        let button = UIButton(configuration: config)
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.seriesButtonDidTapped()
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .systemRed
        
        let image = UIImage(systemName: "circle.fill")?
            .resized(to: Constants.thumbImageSize)?
            .withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        slider.setThumbImage(image, for: .normal)
        return slider
    }()
    
    private lazy var leftTimeLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.labelFont
        label.text = Constants.timeLabelPlaceholder
        label.textColor = .gray
        return label
    }()
    
    private lazy var rightTimeLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.labelFont
        label.text = Constants.timeLabelPlaceholder
        label.textColor = .gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension BottomOverlayView {
    func configureView() {
        backgroundColor = .clear
    }
    
    func configureLayout() {
        [seriesButton, slider, leftTimeLabel, rightTimeLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            seriesButton.topAnchor.constraint(equalTo: topAnchor),
            seriesButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            slider.topAnchor.constraint(equalTo: seriesButton.bottomAnchor, constant: Constants.topConstant),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            leftTimeLabel.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: Constants.topConstant),
            leftTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            rightTimeLabel.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: Constants.topConstant),
            rightTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - Internal methods

extension BottomOverlayView {
    func setLeftTimeTitle(_ title: String) {
        leftTimeLabel.text = title
    }
    
    func setRightTimeTitle(_ title: String) {
        rightTimeLabel.text = title
    }
}
