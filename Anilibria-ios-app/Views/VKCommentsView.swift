//
//  VKCommentsView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 19.04.2024.
//

import UIKit
import WebKit

final class VKCommentsView: UIView {
    let webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.dataDetectorTypes = [.all]
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    private let progressView = UIProgressView(progressViewStyle: .bar)
    
    private var observation: NSKeyValueObservation?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupWebView()
        setupProgressView()
        setupObservation()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        observation = nil
    }
}

// MARK: - Private methods

private extension VKCommentsView {
    func setupView() {
        backgroundColor = .systemBackground
    }
    
    func setupWebView() {
        webView.allowsBackForwardNavigationGestures = true
        webView.underPageBackgroundColor = .systemBackground
    }
    
    func setupProgressView() {
        progressView.tintColor = .systemRed
    }
    
    func setupObservation() {
        observation = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] _, progress in
            guard let value = progress.newValue else { return }
            if value == 1.0 {
                self?.progressView.setProgress(Float(value), animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.progressView.isHidden = true
                    self?.progressView.setProgress(0.0, animated: false)
                }
            } else {
                self?.progressView.isHidden = false
                self?.progressView.setProgress(Float(value), animated: true)
            }
        }
    }
    
    func setupLayout() {
        addSubview(webView)
        addSubview(progressView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            webView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - Internal methods

extension VKCommentsView {
    func loadHTML(html: String, url: URL?) {
        webView.loadHTMLString(html, baseURL: url)
    }
}
