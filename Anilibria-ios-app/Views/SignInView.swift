//
//  SignInView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 14.10.2023.
//

import UIKit

protocol SignInViewDelegate: AnyObject {
    func signInButtonTapped(email: String, password: String)
}

final class SignInView: UIView {
    weak var delegate: SignInViewDelegate?
    private var textFieldsVStack = UIStackView()
    private var emailTextField = UITextField()
    private var passwordTextField = UITextField()
    private var activityIndicator = UIActivityIndicatorView()
    
    private lazy var eyeImageView = UIImage(systemName: Strings.SignInView.ImageName.eye)
    private lazy var eyeSlashImageView = UIImage(systemName: Strings.SignInView.ImageName.eyeSlash)
    
    private var signInButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        
        configureView()
        setupTextFieldsVStack()
        setupEmailTextField()
        setupPasswordTextField()
        setupActivityIndicator()
        setupSignInButton()
        
        addSubview(textFieldsVStack)
        addSubview(signInButton)
        
        textFieldsVStack.addArrangedSubview(emailTextField)
        textFieldsVStack.addArrangedSubview(passwordTextField)
        textFieldsVStack.addArrangedSubview(activityIndicator)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 25
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        layer.borderWidth = 2
        layer.borderColor = UIColor.secondarySystemBackground.cgColor
    }
    
    private func setupTextFieldsVStack() {
        textFieldsVStack.axis = .vertical
        textFieldsVStack.spacing = 16
        textFieldsVStack.alignment = .fill
        textFieldsVStack.distribution = .fill
    }
    
    private func setupEmailTextField() {
        emailTextField.borderStyle = .roundedRect
        emailTextField.tintColor = .systemRed
        emailTextField.placeholder = Strings.SignInView.email
        emailTextField.keyboardType = .emailAddress
        
        emailTextField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
    }
    
    private func setupPasswordTextField() {
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.tintColor = .systemRed
        passwordTextField.placeholder = Strings.SignInView.password
        
        passwordTextField.isSecureTextEntry = true
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(passwordTextFieldRightViewTapped(sender:)))
        
        passwordTextField.rightView = UIImageView(image: eyeImageView)
        passwordTextField.rightView?.addGestureRecognizer(tapGestureRecognizer)
        passwordTextField.rightView?.isUserInteractionEnabled = true
        passwordTextField.rightView?.tintColor = .secondaryLabel
        passwordTextField.rightViewMode = .always
        
        passwordTextField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
    }
    
    private func setupActivityIndicator() {
        activityIndicator.style = .medium
        activityIndicator.color = .systemRed
        activityIndicator.hidesWhenStopped = true
    }
    
    private func setupSignInButton() {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .dynamic
        config.buttonSize = .large
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .systemRed
        config.title = Strings.SignInView.signInButton

        signInButton.configuration = config
        
        signInButton.addAction(UIAction { [weak self] _ in
            self?.delegate?.signInButtonTapped(
                email: self?.emailTextField.text ?? "",
                password: self?.passwordTextField.text ?? "")
        }, for: .touchUpInside)
        
        signInButton.isEnabled = false
    }
    
    private func setupConstraints() {
        textFieldsVStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textFieldsVStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            textFieldsVStack.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7)
        ])
        
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            signInButton.topAnchor.constraint(equalTo: textFieldsVStack.bottomAnchor, constant: 25),
            signInButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    func signInButton(isEnabled status: Bool) {
        signInButton.isEnabled = status
    }
        
    func activityIndicator(animation: Bool) {
        UIView.animate(withDuration: 0.5) {
            if animation == true {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

// MARK: - Targets

extension SignInView {
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
