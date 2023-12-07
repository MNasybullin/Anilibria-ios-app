//
//  VideoPlayerSettingsController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 05.12.2023.
//

import UIKit

final class VideoPlayerSettingsController: UITableViewController {
    private let currentHLS: HLS
    private let hls: [HLS]
    private let currentRate: PlayerRate
    
    init(hls: [HLS], currentHLS: HLS, rate: PlayerRate) {
        self.currentHLS = currentHLS
        self.hls = hls
        self.currentRate = rate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationItem()
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setupNavigationItem() {
        navigationItem.title = "Настройки"
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonDidTapped))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeButtonDidTapped() {
        dismiss(animated: true)
    }
}

// MARK: -

extension VideoPlayerSettingsController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("did tapped row", indexPath)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlayerSettingsRow.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let rowInfo = PlayerSettingsRow.init(rawValue: indexPath.row) else {
            fatalError("Row init error with rawValue = \(indexPath.row)")
        }
        var configuration = UIListContentConfiguration.valueCell()
        configuration.text = rowInfo.description
        switch rowInfo {
            case .quality:
                configuration.secondaryText = currentHLS.description
            case .rate:
                configuration.secondaryText = currentRate.description
        }
        cell.contentConfiguration = configuration
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
