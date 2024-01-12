//
//  NetworkConstants.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 08.12.2023.
//

import Foundation

enum NetworkConstants {
    static let anilibriaURL = "https://www.anilibria.tv"
    static let baseImagesURL = "https://static.anilibria.tv"
    static let mirrorAnilibriaURL = "https://anilibria-ios-app.anilib.moe"
    static let mirrorBaseImagesURL = "https://static.anilib.moe"
    static let apiAnilibriaURL = "https://api.anilibria.tv"
    static let youTubeWatchURL = "https://www.youtube.com/watch?v="
    static let getYouTube = "/v2/getYouTube"
    static let getTitle = "/v2/getTitle"
    static let getTitles = "/v2/getTitles"
    static let getUpdates = "/v2/getUpdates"
    static let getChanges = "/v2/getChanges"
    static let getSchedule = "/v2/getSchedule"
    static let getRandomTitle = "/v2/getRandomTitle"
    static let getYears = "/v2/getYears"
    static let getGenres = "/v2/getGenres"
    static let getTeam = "/v2/getTeam"
    static let getCachingNodes = "/v2/getCachingNodes"
    static let searchTitles = "/v2/searchTitles"
    static let login = "/public/login.php"
    static let logout = "/public/logout.php"
    static let profile = "/public/api/index.php"
    static let getFavorites = "/v2/getFavorites"
    static let addFavorite = "/v2/addFavorite"
    static let delFavorite = "/v2/delFavorite"
    
    static let removeTorrents: URLQueryItem = URLQueryItem(name: "remove", value: "torrents")
}
