//
//  VKCommentsModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 20.04.2024.
//

import Foundation

final class VKCommentsModel {
    private let data: AnimeItem
    private let appRemoteConfig = AppRemoteConfig.shared
    
    init(data: AnimeItem) {
        self.data = data
    }
}

// MARK: - Internal methods

extension VKCommentsModel {
    func getCommentsURLComponents() -> URLComponents? {
        let animeURL = appRemoteConfig.string(forKey: .anilibriaURL) + "/release/\(data.code).html"
        let appID = appRemoteConfig.number(forKey: .vkCommentsAnilibriaAppID)
        let limit = 10
        var urlComponents = URLComponents(string: NetworkConstants.vkCommentsURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: "app", value: String(appID)),
            URLQueryItem(name: "norealtime", value: "0"),
            URLQueryItem(name: "page", value: "0"),
            URLQueryItem(name: "status_publish", value: "0"),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "attach", value: "*"),
            URLQueryItem(name: "url", value: animeURL)
        ]
        return urlComponents
    }
    
    func getHTML() -> String {
        let urlComponents = getCommentsURLComponents()
        let url = urlComponents?.string ?? ""

        let html = """
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
            <style>
                body, html {
                    margin: 0;
                    padding: 0;
                    height: 100%;
                    overflow: hidden;
                }
                #iframeContainer {
                    position: relative;
                    width: 100%;
                    height: 100%;
                }
                iframe {
                    position: absolute;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    border: none;
                }
            </style>
        </head>
        <body>
            <div id="iframeContainer">
                <iframe src="\(url)"></iframe>
            </div>
        </body>
        </html>
        """
        return html
    }
    
}
