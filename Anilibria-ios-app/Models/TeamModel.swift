//
//  TeamModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 13.02.2024.
//

import Foundation

final class TeamModel {
    private let rawData: TeamAPIModel
    private let data: [Team]
    
    init(rawData: TeamAPIModel) {
        self.rawData = rawData
        self.data = Self.convertToTeam(from: rawData)
    }
    
    static private func convertToTeam(from model: TeamAPIModel) -> [Team] {
        var team = [Team]()
        team.append(Team.voice(model.voice))
        team.append(Team.translator(model.translator))
        team.append(Team.editing(model.editing))
        team.append(Team.decor(model.decor))
        team.append(Team.timing(model.timing))
        return team
    }
    
    func getData() -> [Team] {
        data
    }
}
