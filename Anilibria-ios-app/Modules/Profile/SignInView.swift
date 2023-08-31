//
//  SignInView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 30.08.2023.
//

import UIKit

protocol SignInViewDelegate: AnyObject {
    func signInButtonTapped()
}

class SignInView: UIView {
    var delegate: SignInViewDelegate?
    
    private lazy var mainVStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16 * 1.5
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var textFieldsVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.tintColor = .systemRed
        textField.placeholder = Strings.SignInView.email
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.tintColor = .systemRed
        textField.placeholder = Strings.SignInView.password
        
        textField.isSecureTextEntry = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(passwordTextFieldRightViewTapped(sender:)))
        
        textField.rightView = UIImageView(image: eyeImageView)
        textField.rightView?.addGestureRecognizer(tapGestureRecognizer)
        textField.rightView?.isUserInteractionEnabled = true
        textField.rightView?.tintColor = .black
        textField.rightViewMode = .always
        return textField
    }()
    
    private lazy var eyeImageView: UIImage? = {
        return UIImage(systemName: "eye")
    }()
    
    private lazy var eyeSlashImageView: UIImage? = {
        return UIImage(systemName: "eye.slash")
    }()
    
    @objc private func passwordTextFieldRightViewTapped(sender: UITapGestureRecognizer) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        (passwordTextField.rightView as? UIImageView)?.image = passwordTextField.isSecureTextEntry ? eyeImageView : eyeSlashImageView
    }
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var signInButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .dynamic
        config.buttonSize = .large
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .systemRed
        config.title = Strings.SignInView.signInButton

        let button = UIButton(configuration: config)
        
        button.addAction(UIAction { [weak self] _ in
            self?.signInButton.isEnabled = false
            self?.delegate?.signInButtonTapped()
        }, for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .secondarySystemBackground
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        addSubview(mainVStack)
        
        mainVStack.addArrangedSubview(textFieldsVStack)
        mainVStack.addArrangedSubview(buttonStack)
        
        textFieldsVStack.addArrangedSubview(emailTextField)
        textFieldsVStack.addArrangedSubview(passwordTextField)
        
        buttonStack.addArrangedSubview(signInButton)
        
        setupConsraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConsraints() {
        NSLayoutConstraint.activate([
            mainVStack.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            mainVStack.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            mainVStack.centerXAnchor.constraint(equalTo: self.layoutMarginsGuide.centerXAnchor),
            mainVStack.centerYAnchor.constraint(equalTo: self.layoutMarginsGuide.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            buttonStack.widthAnchor.constraint(equalTo: mainVStack.widthAnchor, multiplier: 0.5),
            buttonStack.centerXAnchor.constraint(equalTo: self.layoutMarginsGuide.centerXAnchor)
        ])
    }
    
    func getEmail() -> String {
        return self.emailTextField.text ?? ""
    }
    
    func getPassword() -> String {
        return self.passwordTextField.text ?? ""
    }
    
    func signInButton(isEnabled status: Bool) {
        signInButton.isEnabled = status
    }
}

#if DEBUG

// MARK: - Live Preview In UIKit
import SwiftUI
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            SignInView()
        }
        .frame(height: 300)
    }
}

#endif
