//
//  VideoPlayerSettingsDetailController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 07.12.2023.
//

import UIKit

final class VideoPlayerSettingsDetailController<T: CustomStringConvertible>: UITableViewController {
    
    private let cellIdentifier = "Cell"
    private var navTitle: String
    private var data: [T]
    private var currentItem: T
    private var selectedIndexPath: IndexPath?
    private var selectedItemCompletion: (_ selectedItem: T) -> Void
    
    init(data: [T], currentItem: T, title: String, selecteItemCompletion: @escaping (_ selectedItem: T) -> Void) {
        self.data = data
        self.currentItem = currentItem
        self.navTitle = title
        self.selectedItemCompletion = selecteItemCompletion
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func setupNavigationItem() {
        navigationItem.title = navTitle
        navigationController?.navigationBar.tintColor = .systemRed
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonDidTapped))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeButtonDidTapped() {
        dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let selectedIndexPath {
            let selectedCell = tableView.cellForRow(at: selectedIndexPath)
            selectedCell?.accessoryType = .none
        }
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        selectedIndexPath = indexPath
        
        selectedItemCompletion(data[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let item = data[indexPath.row]
        var configuration = UIListContentConfiguration.cell()
        configuration.text = item.description
        cell.contentConfiguration = configuration
        cell.tintColor = .systemRed
        if item.description == currentItem.description {
            cell.accessoryType = .checkmark
            selectedIndexPath = indexPath
        }
        return cell
    }
}
