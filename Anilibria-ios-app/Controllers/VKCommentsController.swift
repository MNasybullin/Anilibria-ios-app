//
//  VKCommentsController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 19.04.2024.
//

import UIKit
import WebKit

final class VKCommentsController: UIViewController, HasCustomView {
    typealias CustomView = VKCommentsView
    
    private let model: VKCommentsModel
    
    init(data: AnimeItem) {
        model = VKCommentsModel(data: data)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let vkCommentsView = VKCommentsView()
        vkCommentsView.webView.navigationDelegate = self
        vkCommentsView.webView.uiDelegate = self
        view = vkCommentsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadHTML()
    }
}

// MARK: - Private methods

private extension VKCommentsController {
    func loadHTML() {
        let html = model.getHTML()
        customView.loadHTML(html: html, url: nil)
    }
}

// MARK: - WKUIDelegate

extension VKCommentsController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}

// MARK: - WKNavigationDelegate

extension VKCommentsController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Проверяем URL-адрес после полной загрузки.
        // После авторизации в ВК, сервис перекидывает на пустой сайт(скрипт не срабатывает).
        if let currentURL = webView.url?.absoluteString, currentURL.contains("login.php?act=widget&_openBrowser=1") {
            // Загружаем основную страницу с комментариями
            loadHTML()
        }
    }
}
