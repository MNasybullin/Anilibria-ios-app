//
//  TeamContentController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 13.02.2024.
//

import UIKit

final class TeamContentController: NSObject {
    
    private let customView: TeamView
    private let model: TeamModel
    private let data: [Team]
    
    init(customView: TeamView, rawData: TeamAPIModel) {
        self.customView = customView
        self.model = TeamModel(rawData: rawData)
        self.data = model.getData()
        super.init()
        
        setupTableView()
    }
}

// MARK: - Private methods

private extension TeamContentController {
    func setupTableView() {
        customView.tableView.delegate = self
        customView.tableView.dataSource = self
    }
}

// MARK: - UITableViewDelegate

extension TeamContentController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension TeamContentController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data[section].nicknames.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        data[section].description
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
        
        let section = indexPath.section
        let row = indexPath.row
        
        var content = cell.defaultContentConfiguration()
        content.text = data[section].nicknames[row]
        cell.contentConfiguration = content
        return cell
    }
}
