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
    private enum Constants {
        static let cornerRadius: CGFloat = 25
        static let textFieldsVStackSpacing: CGFloat = 16
    }
    
    weak var delegate: SignInViewDelegate?
    
    private var textFieldsVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.textFieldsVStackSpacing
        return stack
    }()
    
    private var emailTextField = UITextField()
    private var passwordTextField = UITextField()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.color = .systemRed
        return activityIndicator
    }()
    
    private lazy var eyeImageView = UIImage(systemName: Strings.SignInView.ImageName.eye)
    private lazy var eyeSlashImageView = UIImage(systemName: Strings.SignInView.ImageName.eyeSlash)
    
    private lazy var passwordRightView: UIView = {
        let rightView = UIView()
        let imageView = UIImageView(image: eyeImageView)
        
        rightView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: rightView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: rightView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: rightView.trailingAnchor, constant: -8),
            imageView.bottomAnchor.constraint(equalTo: rightView.bottomAnchor)
        ])
        return rightView
    }()
    
    private var signInButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        
        setupView()
        setupEmailTextField()
        setupPasswordTextField()
        setupSignInButton()
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemGroupedBackground
        layer.cornerRadius = Constants.cornerRadius
    }
    
    private func setupEmailTextField() {
        emailTextField.delegate = self
        emailTextField.borderStyle = .roundedRect
        emailTextField.tintColor = .systemRed
        emailTextField.placeholder = Strings.SignInView.email
        emailTextField.textContentType = .username
        emailTextField.keyboardType = .emailAddress
        emailTextField.returnKeyType = .next
        
        emailTextField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
    }
    
    private func setupPasswordTextField() {
        passwordTextField.delegate = self
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.tintColor = .systemRed
        passwordTextField.placeholder = Strings.SignInView.password
        passwordTextField.textContentType = .password
        passwordTextField.isSecureTextEntry = true
        passwordTextField.returnKeyType = .send
        
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(passwordTextFieldRightViewTapped(sender:))
        )
        
        passwordTextField.rightView = passwordRightView
        passwordTextField.rightView?.addGestureRecognizer(tapGestureRecognizer)
        passwordTextField.rightView?.isUserInteractionEnabled = true
        passwordTextField.rightView?.tintColor = .secondaryLabel
        passwordTextField.rightViewMode = .always
        
        passwordTextField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
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
            self?.emailTextField.resignFirstResponder()
            self?.passwordTextField.resignFirstResponder()
            self?.delegate?.signInButtonTapped(
                email: self?.emailTextField.text ?? "",
                password: self?.passwordTextField.text ?? "")
        }, for: .touchUpInside)
        
        signInButton.isEnabled = false
    }
    
    private func configureLayout() {
        addSubview(textFieldsVStack)
        addSubview(signInButton)
        
        textFieldsVStack.addArrangedSubview(emailTextField)
        textFieldsVStack.addArrangedSubview(passwordTextField)
        textFieldsVStack.addArrangedSubview(activityIndicator)
        
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
}

// MARK: - Internal methods

extension SignInView {
    func signInButton(isEnabled status: Bool) {
        signInButton.isEnabled = status
    }
    
    func activityIndicator(animation: Bool) {
        UIView.animate(withDuration: 0.5) {
            if animation == true {
                self.signInButton.isEnabled = false
                self.emailTextField.isUserInteractionEnabled = false
                self.activityIndicator.startAnimating()
            } else {
                self.signInButton.isEnabled = true
                self.emailTextField.isUserInteractionEnabled = true
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func clearTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
        textFieldsChanged()
    }
}

// MARK: - Targets

extension SignInView {
    @objc private func passwordTextFieldRightViewTapped(sender: UITapGestureRecognizer) {
        passwordTextField.isSecureTextEntry.toggle()
        guard let imageView = passwordTextField.rightView?.subviews.first as? UIImageView else { return }
        imageView.image = passwordTextField.isSecureTextEntry ? eyeImageView : eyeSlashImageView
    }
    
    @objc private func textFieldsChanged() {
        if emailTextField.hasText && passwordTextField.hasText {
            signInButton.isEnabled = true
        } else {
            signInButton.isEnabled = false
        }
    }
}

// MARK: - UITextFieldDelegate

extension SignInView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            if emailTextField.hasText && passwordTextField.hasText {
                passwordTextField.resignFirstResponder()
                delegate?.signInButtonTapped(
                    email: emailTextField.text ?? "",
                    password: passwordTextField.text ?? "")
            }
        }
        return true
    }
}
