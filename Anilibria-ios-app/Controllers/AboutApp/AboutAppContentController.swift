//
//  AboutAppContentController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 19.02.2024.
//

import UIKit

protocol AboutAppContentControllerDelegate: AnyObject {
    func githubItemDidSelected(url: URL)
}

final class AboutAppContentController: NSObject {
    typealias Localization = Strings.AboutAppModule
    
    enum Section: Int, CaseIterable {
        case version
        case github
    }
    
    private let customView: AboutAppView
    private let model = AboutAppModel()
    weak var delegate: AboutAppContentControllerDelegate?
    
    init(customView: AboutAppView) {
        self.customView = customView
        super.init()
        
        setupTableView()
    }
}

// MARK: - Private methods

private extension AboutAppContentController {
    func setupTableView() {
        customView.tableView.dataSource = self
        customView.tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource

extension AboutAppContentController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return Localization.disclaimer
        }
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
        guard let section = Section(rawValue: indexPath.section) else {
            return cell
        }
        switch section {
            case .version:
                configureVersionCell(cell)
            case .github:
                configureGitHubCell(cell)
        }
        return cell
    }
    
    private func configureVersionCell(_ cell: UITableViewCell) {
        var content = cell.defaultContentConfiguration()
        content.text = Localization.version + " \(model.getAppVersion())"
        cell.contentConfiguration = content
    }
    
    private func configureGitHubCell(_ cell: UITableViewCell) {
        var content = cell.defaultContentConfiguration()
        content.text = Localization.github
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
    }
}

// MARK: - UITableViewDelegate

extension AboutAppContentController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let section = Section(rawValue: indexPath.section) else {
            return
        }
        switch section {
            case .version: break
            case .github:
                let url = model.getGithubURL()
                delegate?.githubItemDidSelected(url: url)
        }
    }
}
