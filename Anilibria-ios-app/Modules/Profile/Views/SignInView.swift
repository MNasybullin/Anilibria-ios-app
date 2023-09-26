//
//  SignInView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 30.08.2023.
//

import UIKit

protocol SignInViewDelegate: AnyObject {
    func signInButtonTapped(email: String, password: String)
}

final class SignInView: UIView {
    var delegate: SignInViewDelegate?
    
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
        
        textField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.tintColor = .systemRed
        textField.placeholder = Strings.SignInView.password
        
        textField.isSecureTextEntry = true
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(passwordTextFieldRightViewTapped(sender:)))
        
        textField.rightView = UIImageView(image: eyeImageView)
        textField.rightView?.addGestureRecognizer(tapGestureRecognizer)
        textField.rightView?.isUserInteractionEnabled = true
        textField.rightView?.tintColor = .secondaryLabel
        textField.rightViewMode = .always
        
        textField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        
        return textField
    }()
    
    private lazy var eyeImageView: UIImage? = {
        return UIImage(systemName: Strings.SignInView.ImageName.eye)
    }()
    
    private lazy var eyeSlashImageView: UIImage? = {
        return UIImage(systemName: Strings.SignInView.ImageName.eyeSlash)
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
            self?.delegate?.signInButtonTapped(
                email: self?.emailTextField.text ?? "",
                password: self?.passwordTextField.text ?? "")
        }, for: .touchUpInside)
        
        button.isEnabled = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 25
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        
        addSubview(textFieldsVStack)
        addSubview(signInButton)
        
        textFieldsVStack.addArrangedSubview(emailTextField)
        textFieldsVStack.addArrangedSubview(passwordTextField)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        textFieldsVStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textFieldsVStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textFieldsVStack.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7)
        ])
        
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            signInButton.topAnchor.constraint(equalTo: textFieldsVStack.bottomAnchor, constant: 25),
            signInButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func passwordTextFieldRightViewTapped(sender: UITapGestureRecognizer) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        guard let rightView = passwordTextField.rightView as? UIImageView else { return }
        rightView.image = passwordTextField.isSecureTextEntry ? eyeImageView : eyeSlashImageView
    }
    
    @objc private func textFieldsChanged() {
        if emailTextField.hasText && passwordTextField.hasText {
            signInButton.isEnabled = true
        } else {
            signInButton.isEnabled = false
        }
    }
    
}

extension SignInView {
    func signInButton(isEnabled status: Bool) {
        signInButton.isEnabled = status
    }
    
    func emailTextField(isEnabled status: Bool) {
        emailTextField.isEnabled = status
    }
    
    func passwordTextField(isEnabled status: Bool) {
        passwordTextField.isEnabled = status
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
        .frame(height: 200)
    }
}

#endif
