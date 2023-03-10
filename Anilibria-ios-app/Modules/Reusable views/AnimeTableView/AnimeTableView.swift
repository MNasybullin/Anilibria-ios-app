//
//  AnimeTableView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 08.03.2023.
//

import Foundation
import UIKit
import SkeletonView

protocol AnimeTableViewDelegate: AnyObject {
    func getData()
    func getImage(forIndexPath indexPath: IndexPath)
}

final class AnimeTableView: UITableView {
    weak var animeTableViewDelegate: AnimeTableViewDelegate?
    
    private let cellIdentifier = "AnimeCell"
    
    private var heightForRow: CGFloat
    private var data: [AnimeTableViewModel]?
    
    init(heightForRow: CGFloat) {
        self.heightForRow = heightForRow
        super.init(frame: .zero, style: .plain)
        
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTableView() {
        register(AnimeTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        delegate = self
        dataSource = self
        backgroundColor = .systemBackground
        isSkeletonable = true
    }
    
    func updateData(_ data: [AnimeTableViewModel]) {
        self.data = data
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    func updateImage(_ image: UIImage, for indexPath: IndexPath) {
        data?[indexPath.row].image = image
        data?[indexPath.row].imageIsLoading = false
        DispatchQueue.main.async {
            self.reconfigureRows(at: [indexPath])
        }
    }
}

// MARK: - UITableViewDelegate
extension AnimeTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("tapped")
    }
}

// MARK: - UITableViewDataSource
extension AnimeTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AnimeTableViewCell else {
            fatalError("Cell is doesn`t AnimeTableViewCell")
        }
        guard data != nil else {
            if sk.isSkeletonActive == false {
//                showAnimatedSkeleton()
                animeTableViewDelegate?.getData()
            }
            return cell
        }
        let index = indexPath.row
        if sk.isSkeletonActive == true {
            hideSkeleton(reloadDataAfter: false)
        }
        
        cell.ruNameLabel.text = data?[index].ruName
        cell.engNameLabel.text = data?[index].engName
        cell.descriptionLabel.text = data?[index].description
        
        guard let image = data?[index].image,
              data?[index].imageIsLoading == false else {
            data?[index].imageIsLoading = true
            cell.animeImageView.image = UIImage(asset: Asset.Assets.blankImage)
            animeTableViewDelegate?.getImage(forIndexPath: indexPath)
            return cell
        }
        cell.animeImageView.image = image
        return cell
    }
}

// MARK: - SkeletonTableViewDataSource
extension AnimeTableView: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return cellIdentifier
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}

#if DEBUG

// MARK: - Live Preview In UIKit
import SwiftUI
struct AnimeTableView_Previews: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            AnimeTableView(heightForRow: 150)
        }
    }
}

#endif
