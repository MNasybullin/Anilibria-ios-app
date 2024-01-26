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
    static let youtube = "/v3/youtube"
    static let title = "/v3/title"
    static let titleList = "/v3/title/list"
    static let titleUpdates = "/v3/title/updates"
    static let titleChanges = "/v3/title/changes"
    static let titleSchedule = "/v3/title/schedule"
    static let titleRandom = "/v3/title/random"
    static let titleSearch = "/v3/title/search"
    static let titleFranchises = "/v3/title/franchises"
    static let franchiseList = "/v3/franchise/list"
    static let years = "/v3/years"
    static let genres = "/v3/genres"
    static let team = "/v3/team"
    static let login = "/public/login.php"
    static let logout = "/public/logout.php"
    static let user = "/v3/user"
    static let getUserFavorites = "/v3/user/favorites"
    static let putUserFavorites = "/v3/user/favorites"
    static let delUserFavorites = "/v3/user/favorites"
    static let noAvatarSuffix = "/upload/avatars/noavatar.jpg"
    
    static let removeTorrents: URLQueryItem = URLQueryItem(name: "remove", value: "torrents")
}
