//
//  Logger+Extension.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 04.03.2024.
//

import OSLog

extension Logger {
    enum Subsystem: String {
        case coreData
        case videoPlayer
        case episode
        case home
        case schedule
        case youtube
        case favorites
        case franchise
        case anime
        case search
        case user
        case profile
    }
    
    enum Category: String {
        case empty = ""
        case coreData
        case image
        case data
    }
    
    init(subsystem: Subsystem, category: Category) {
        self.init(subsystem: subsystem.rawValue, category: category.rawValue)
    }
    
    static func logInfo(file: StaticString = #file, function: StaticString = #function, line: Int = #line) -> String {
        let fileName = URL(fileURLWithPath: file.description).deletingPathExtension().lastPathComponent
        let source = [fileName.description, function.description, String(line)].joined(separator: ":")
        let formattedMessage = source + "\n\n"
        return formattedMessage
    }
}
