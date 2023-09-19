//
//  UserInfoView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 31.08.2023.
//

import UIKit

class UserInfoView: UIView {
    
    private lazy var mainVStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16 * 1.5
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(asset: Asset.Assets.testImage))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.systemRed.cgColor
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26, weight: .regular)
        label.textColor = .label
        label.textAlignment = .center
        label.text = "Test"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .secondarySystemBackground
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        addSubview(mainVStack)
        
        mainVStack.addArrangedSubview(imageView)
        mainVStack.addArrangedSubview(userNameLabel)
        
        setupConstraints()
        #warning("test")
//        imageView.layer.cornerRadius = mainVStack.bounds.width * 0.33 / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainVStack.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            mainVStack.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            mainVStack.centerXAnchor.constraint(equalTo: self.layoutMarginsGuide.centerXAnchor),
            mainVStack.centerYAnchor.constraint(equalTo: self.layoutMarginsGuide.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: mainVStack.widthAnchor, multiplier: 0.33)
        ])
    }
    
    func set(image: UIImage) {
        imageView.image = image
    }
    
    func set(userName: String) {
        userNameLabel.text = userName
    }
    
}

#if DEBUG

// MARK: - Live Preview In UIKit
import SwiftUI
struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            UserInfoView()
        }
        .frame(height: 300)
    }
}

#endif
