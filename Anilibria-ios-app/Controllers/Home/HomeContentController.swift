//
//  HomeContentController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 27.10.2023.
//

import UIKit
import SkeletonView
import OSLog

// swiftlint: disable file_length
protocol HomeContentControllerDelegate: AnyObject {
    func show(_ destination: HomeNavigator.Destination)
    func openURL(_ url: URL)
}

@MainActor
final class HomeContentController: NSObject {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias SectionSnapshot = NSDiffableDataSourceSectionSnapshot<Item>
    typealias Localization = Strings.HomeModule
    
    enum Section: Int, CaseIterable {
        case today
        case watching
        case updates
        case youtube
    }
    
    enum Item: Hashable {
        case today(HomePosterItem, Section)
        case watching(HomeWatchingItem, Section)
        case updates(HomePosterItem, Section)
        case youtube(HomePosterItem, Section)
        
        var section: Section {
            switch self {
                case .today(_, let section):
                    return section
                case .watching(_, let section):
                    return section
                case .updates(_, let section):
                    return section
                case .youtube(_, let section):
                    return section
            }
        }
    }
    
    // MARK: Transition properties
    private (set) var selectedCell: PosterCollectionViewCell?
    private (set) var selectedCellImageViewSnapshot: UIView?
    
    weak var delegate: HomeContentControllerDelegate?
    
    private lazy var dataSource = makeDataSource()
    
    private let todayModel = HomeTodayModel()
    private let watchingModel = HomeWatchingModel()
    private let updatesModel = HomeUpdatesModel()
    private let youtubeModel = HomeYouTubeModel()
    
    private var todayData: [HomePosterItem] = []
    private var watchingData: [HomeWatchingItem] = []
    private var updatesData: [HomePosterItem] = []
    private var youtubeData: [HomePosterItem] = []
    
    private var contextMenuTask: Task<(), Never>?
    
    let customView: HomeView
    
    // Для правильной анимации нажатия ячеек
    var lastTransform: CGAffineTransform?
    
    private var _status: HomeView.Status = .normal
    
    private var status: HomeView.Status {
        get { _status }
        set {
            _status = newValue
            customView.updateView(withStatus: status)
        }
    }
    
    init(customView: HomeView, delegate: HomeContentControllerDelegate?) {
        self.customView = customView
        self.delegate = delegate
        super.init()
        
        setupCollectionView()
        setupModels()
        applyInitialSnapshot()
        requestDataWithLoadingStatus()
    }
    
    func requestDataWithRefreshStatus() {
        requestData(status: .refresh)
    }
    
    func requestDataWithLoadingStatus() {
        requestData(status: .loading)
    }
    
    func requestRefreshWatchingData() {
        guard status == .normal else {
            return
        }
        do {
            watchingData = try watchingModel.requestData()
            applyWatchingSnapshot()
        } catch {
            let logger = Logger(subsystem: .home, category: .data)
            logger.error("\(Logger.logInfo(error: error))")
        }
    }
}

// MARK: - Private methods
private extension HomeContentController {
    func setupCollectionView() {
        customView.collectionView.delegate = self
        customView.collectionView.prefetchDataSource = self
        customView.homeCollectionViewLayout.dataSource = dataSource
    }
    
    func setupModels() {
        youtubeModel.downsampleSize = .init(width: 396, height: 222)
    }
    
    func applyInitialSnapshot() {
        let snapshot = Snapshot()
        dataSource.apply(snapshot)
    }
    
    func todayCellRegistration() -> UICollectionView.CellRegistration<TodayHomePosterCollectionCell, Item> {
        UICollectionView.CellRegistration<TodayHomePosterCollectionCell, Item> { [weak self] cell, indexPath, _ in
            guard let item = self?.todayData[indexPath.row] else {
                return
            }
            
            if item.image == nil {
                Task { [weak self] in
                    guard let self else { return }
                    do {
                        let image = try await self.todayModel.requestImage(fromUrlString: item.imageUrlString)
                        self.todayData[indexPath.row].image = image
                        cell.setImage(image, urlString: item.imageUrlString)
                    } catch {
                        cell.imageViewStopSkeletonAnimation()
                    }
                }
            }
            cell.configureCell(item: item)
        }
    }
    
    func watchingCellRegistration() -> UICollectionView.CellRegistration<WatchingHomeCollectionViewCell, Item> {
        UICollectionView.CellRegistration<WatchingHomeCollectionViewCell, Item> { cell, _, item in
            guard case .watching(let data, _) = item else {
                return
            }
            cell.configureCell(item: data)
        }
    }
    
    func updatesCellRegistration() -> UICollectionView.CellRegistration<UpdatesHomePosterCollectionCell, Item> {
        UICollectionView.CellRegistration<UpdatesHomePosterCollectionCell, Item> { [weak self] cell, indexPath, _ in
            guard let item = self?.updatesData[indexPath.row] else {
                return
            }
            
            if item.image == nil {
                Task { [weak self] in
                    guard let self else { return }
                    do {
                        let image = try await self.updatesModel.requestImage(fromUrlString: item.imageUrlString)
                        self.updatesData[indexPath.row].image = image
                        cell.setImage(image, urlString: item.imageUrlString)
                    } catch {
                        cell.imageViewStopSkeletonAnimation()
                    }
                }
            }
            cell.configureCell(item: item)
        }
    }
    
    func youtubeCellRegistration() -> UICollectionView.CellRegistration<YouTubeHomePosterCollectionCell, Item> {
        UICollectionView.CellRegistration<YouTubeHomePosterCollectionCell, Item> { [weak self] cell, indexPath, _ in
            guard let item = self?.youtubeData[indexPath.row] else {
                return
            }
            
            if item.image == nil {
                Task { [weak self] in
                    guard let self else { return }
                    do {
                        let image = try await self.youtubeModel.requestImage(fromUrlString: item.imageUrlString)
                        self.youtubeData[indexPath.row].image = image
                        cell.setImage(image, urlString: item.imageUrlString)
                    } catch {
                        cell.imageViewStopSkeletonAnimation()
                    }
                }
            }
            cell.configureCell(item: item)
        }
    }
    
    func makeDataSource() -> DataSource {
        let todayCellRegistration = todayCellRegistration()
        let watchingCellRegistration = watchingCellRegistration()
        let updatesCellRegistration = updatesCellRegistration()
        let youtubeCellRegistration = youtubeCellRegistration()
        
        let dataSource = HomeDiffableDataSource(
            collectionView: customView.collectionView,
            cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
                let section = itemIdentifier.section
                
                switch section {
                    case .today:
                        return collectionView.dequeueConfiguredReusableCell(using: todayCellRegistration, for: indexPath, item: itemIdentifier)
                    case .watching:
                        return collectionView.dequeueConfiguredReusableCell(using: watchingCellRegistration, for: indexPath, item: itemIdentifier)
                    case .updates:
                        return collectionView.dequeueConfiguredReusableCell(using: updatesCellRegistration, for: indexPath, item: itemIdentifier)
                    case .youtube:
                        return collectionView.dequeueConfiguredReusableCell(using: youtubeCellRegistration, for: indexPath, item: itemIdentifier)
                }
            })
        
        makeSupplementaryViewProvider(dataSource: dataSource)
        return dataSource
    }
    
    func makeSupplementaryViewProvider(dataSource: DataSource) {
        dataSource.supplementaryViewProvider = { [weak self, weak dataSource] collectionView, kind, indexPath in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeHeaderSupplementaryView.reuseIdentifier, for: indexPath) as? HomeHeaderSupplementaryView else {
                fatalError("Can`t create header view")
            }
            
            guard let section = dataSource?.sectionIdentifier(for: indexPath.section) else {
                fatalError("Section is not found in HomeContentController")
            }
            switch section {
                case .today:
                    headerView.configureView(
                        titleLabelText: Localization.Title.today,
                        titleButtonText: Localization.ButtonTitle.allDays) { [weak self] in
                            self?.delegate?.show(.schedule)
                        }
                case .watching:
                    headerView.configureView(titleLabelText: Localization.Title.watching)
                case .updates:
                    headerView.configureView(titleLabelText: Localization.Title.updates)
                case .youtube:
                    headerView.configureView(
                        titleLabelText: Localization.Title.youTube,
                        titleButtonText: Localization.ButtonTitle.all) { [weak self] in
                            guard let self else { return }
                            let rawData = youtubeModel.getRawData()
                            self.delegate?.show(.youTube(data: youtubeData, rawData: rawData))
                        }
            }
            return headerView
        }
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        
        let watchingArray = watchingData.map {
            Item.watching($0, .watching)
        }
        
        var noImageData = [Item]()
        var todayArray = [Item]()
        todayData.forEach {
            let item = Item.today($0, .today)
            todayArray.append(item)
            if $0.image == nil {
                noImageData.append(item)
            }
        }
        var updatesArray = [Item]()
        updatesData.forEach {
            let item = Item.updates($0, .updates)
            updatesArray.append(item)
            if $0.image == nil {
                noImageData.append(item)
            }
        }
        var youtubeArray = [Item]()
        youtubeData.forEach {
            let item = Item.youtube($0, .youtube)
            youtubeArray.append(item)
            if $0.image == nil {
                noImageData.append(item)
            }
        }
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(todayArray, toSection: .today)
        if !watchingArray.isEmpty {
            snapshot.appendItems(watchingArray, toSection: .watching)
        } else {
            snapshot.deleteSections([.watching])
        }
        snapshot.appendItems(updatesArray, toSection: .updates)
        snapshot.appendItems(youtubeArray, toSection: .youtube)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        
        // for skeletonView. (Иначе пропадает skeleton на image)
        if !noImageData.isEmpty {
            var noImageSnapshot = dataSource.snapshot()
            noImageSnapshot.reconfigureItems(noImageData)
            dataSource.apply(noImageSnapshot)
        }
    }
    
    func applyWatchingSnapshot() {
        var snapshot = dataSource.snapshot()
        
        guard !watchingData.isEmpty else {
            if snapshot.sectionIdentifiers.contains(where: { $0 == .watching }) {
                snapshot.deleteSections([.watching])
                dataSource.apply(snapshot)
            }
            return
        }
        
        let watchingArray = watchingData.map { Item.watching($0, .watching) }
        
        if snapshot.sectionIdentifiers.contains(where: { $0 == .watching }) {
            var sectionSnapshot = SectionSnapshot()
            sectionSnapshot.append(watchingArray)
            dataSource.apply(sectionSnapshot, to: .watching)
        } else {
            snapshot.insertSections([.watching], afterSection: .today)
            snapshot.appendItems(watchingArray, toSection: .watching)
            dataSource.apply(snapshot)
        }
    }
    
    func requestData(status setStatus: HomeView.Status) {
        guard status != .loading && status != .refresh else { return }
        status = setStatus
        Task(priority: .userInitiated) {
            do {
                async let today = todayModel.requestData()
                async let updates = updatesModel.requestData()
                async let youtube = youtubeModel.requestData()
                
                await todayData = try today
                await updatesData = try updates
                await youtubeData = try youtube
                watchingData = try watchingModel.requestData()
                
                status = .normal
                applySnapshot()
            } catch {
                let logger = Logger(subsystem: .home, category: .data)
                logger.error("\(Logger.logInfo(error: error))")
                status = .error(error)
            }
        }
    }
    
    func cancelRequestImage(indexPath: IndexPath) {
        guard let section = dataSource.sectionIdentifier(for: indexPath.section) else {
            return
        }
        let row = indexPath.row
        switch section {
            case .today:
                cancelImageTaskIfNeeded(data: todayData, model: todayModel, row: row)
            case .watching:
                break
            case .updates:
                cancelImageTaskIfNeeded(data: updatesData, model: updatesModel, row: row)
            case .youtube:
                cancelImageTaskIfNeeded(data: youtubeData, model: youtubeModel, row: row)
        }
    }
    
    private func cancelImageTaskIfNeeded(data: [HomePosterItem], model: ImageModel, row: Int) {
        guard let item = data[safe: row],
                item.image == nil else {
            return
        }
        model.cancelImageTask(forUrlString: item.imageUrlString)
    }
}

// MARK: - Context Menu in CollectionView

private extension HomeContentController {
    func configureWatchingContextMenu(at indexPath: IndexPath) -> UIContextMenuConfiguration? {
        guard let item = dataSource.itemIdentifier(for: indexPath),
                case .watching(let data, _) = item else {
            return nil
        }
        var children = [UIMenuElement]()
        
        if #available(iOS 16.0, *) {
            let aboutAnimeAction = configureAboutAnimeAction(data: data)
            children.append(aboutAnimeAction)
            
            let episodesAction = configureEpisodesAction(data: data)
            children.append(episodesAction)
        }
        let hideAction = configureHideAction(data: data, indexPath: indexPath)
        children.append(hideAction)
        
        let actionProvider: UIContextMenuActionProvider = { _ in
            UIMenu(children: children)
        }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: actionProvider)
    }
    
    @available(iOS 16.0, *)
    func configureAboutAnimeAction(data: HomeWatchingItem) -> UIAction {
        UIAction(title: Localization.WatchingMenu.aboutAnimeTitle,
                 image: UIImage(systemName: Localization.WatchingMenu.aboutAnimeImageName),
               attributes: [.keepsMenuPresented]) { [weak self] _ in
            guard let self else { return }
            self.updateContextMenuForLoading()
            self.contextMenuRequestAnimeTask(animeId: data.id) { [weak self] data in
                self?.delegate?.show(.anime(data: data, image: nil, hasInteractiveTransitionController: false))
            }
        }
    }
    
    @available(iOS 16.0, *)
    func configureEpisodesAction(data: HomeWatchingItem) -> UIAction {
        UIAction(title: Localization.WatchingMenu.episodesTitle,
                 image: UIImage(systemName: Localization.WatchingMenu.episodesImageName),
               attributes: [.keepsMenuPresented]) { [weak self] _ in
            guard let self else { return }
            self.updateContextMenuForLoading()
            self.contextMenuRequestAnimeTask(animeId: data.id) { [weak self] data in
                self?.delegate?.show(.episodes(data: data))
            }
        }
    }
    
    func configureHideAction(data: HomeWatchingItem, indexPath: IndexPath) -> UIAction {
        UIAction(title: Localization.WatchingMenu.hideTitle,
               image: UIImage(systemName: Localization.WatchingMenu.hideImageName),
               attributes: [.destructive]) { [weak self] _ in
            self?.hideWatchingItem(id: data.id, at: indexPath)
        }
    }
    
    func contextMenuRequestAnimeTask(animeId: Int, completionBlock: @escaping (_ data: TitleAPIModel) -> Void) {
        contextMenuTask = Task(priority: .userInitiated) {
            do {
                let data = try await self.watchingModel.requestAnimeData(forAnimeId: animeId)
                customView.collectionView.contextMenuInteraction?.dismissMenu()
                selectedCell = nil
                selectedCellImageViewSnapshot = nil
                completionBlock(data)
            } catch {
                let logger = Logger(subsystem: .home, category: .data)
                logger.error("\(Logger.logInfo(error: error))")
                let notificationData = NotificationBannerView.BannerData(title: "Ошибка загрузки",
                                                                detail: error.localizedDescription,
                                                                type: .error)
                customView.collectionView.contextMenuInteraction?.dismissMenu()
                NotificationBannerView(data: notificationData).show(onView: customView)
            }
        }
    }
    
    func updateContextMenuForLoading() {
        customView.collectionView.contextMenuInteraction?.updateVisibleMenu({ menu in
            let action = UIAction(title: Localization.WatchingMenu.loadingDataTitle, attributes: [.disabled]) { _ in
            }
            return menu.replacingChildren([action])
        })
    }
    
    func hideWatchingItem(id: Int, at indexPath: IndexPath) {
        do {
            try watchingModel.hideWatchingEntity(id: id)
            watchingData.remove(at: indexPath.row)
            applyWatchingSnapshot()
        } catch {
            let logger = Logger(subsystem: .home, category: .coreData)
            logger.error("\(Logger.logInfo(error: error))")
            
            let data = NotificationBannerView.BannerData(title: Localization.Error.failedHidingWatched,
                                                         detail: error.localizedDescription,
                                                         type: .error)
            NotificationBannerView(data: data).show()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension HomeContentController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let section = dataSource.sectionIdentifier(for: indexPath.section) else {
            fatalError("Section is not found in HomeContentController")
        }
        
        selectedCell = collectionView.cellForItem(at: indexPath) as? PosterCollectionViewCell
        selectedCellImageViewSnapshot = selectedCell?.imageView.snapshotView(afterScreenUpdates: false)
        
        let row = indexPath.row
        switch section {
            case .today:
                didSelectTodayCell(indexPath: indexPath)
            case .watching:
                didSelectWatchingCell(indexPath: indexPath)
            case .updates:
                didSelectUpdatesCell(indexPath: indexPath)
            case .youtube:
                didSelectYoutubeCell(indexPath: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cancelRequestImage(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        lastTransform = cell.transform
        collectionView.animateCellHighlight(at: indexPath, highlighted: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        collectionView.animateCellHighlight(at: indexPath, highlighted: false, lastTransform: lastTransform)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let section = dataSource.sectionIdentifier(for: indexPath.section) else {
            return nil
        }
        switch section {
            case .watching:
                return configureWatchingContextMenu(at: indexPath)
            default:
                return nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willEndContextMenuInteraction configuration: UIContextMenuConfiguration, animator: (any UIContextMenuInteractionAnimating)?) {
        contextMenuTask?.cancel()
    }
}

// MARK: - Did Select Cell

private extension HomeContentController {
    func didSelectTodayCell(indexPath: IndexPath) {
        let row = indexPath.row
        guard let rawData = todayModel.getRawData(row: row) else { return }
        let image = todayData[row].image
        delegate?.show(.anime(data: rawData, image: image))
    }
    
    func didSelectWatchingCell(indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        if case .watching(let data, _) = item {
            delegate?.show(.videoPlayer(animeId: data.id, numberOfEpisode: data.numberOfEpisode))
        }
    }
    
    func didSelectUpdatesCell(indexPath: IndexPath) {
        let row = indexPath.row
        guard let rawData = updatesModel.getRawData(row: row) else { return }
        let image = updatesData[row].image
        delegate?.show(.anime(data: rawData, image: image))
    }
    
    func didSelectYoutubeCell(indexPath: IndexPath) {
        guard let data = youtubeModel.getRawData(row: indexPath.row) else { return }
        let urlString = NetworkConstants.youTubeWatchURL + data.youtubeId
        guard let url = URL(string: urlString) else { return }
        delegate?.openURL(url)
    }
}

// MARK: - UICollectionViewDataSourcePrefetching

// swiftlint: disable cyclomatic_complexity
extension HomeContentController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            guard let section = dataSource.sectionIdentifier(for: indexPath.section) else {
                return
            }
            let row = indexPath.row
            switch section {
                case .today:
                    guard let item = todayData[safe: row], 
                            item.image == nil else {
                        return
                    }
                    Task { [weak self] in
                        guard let self else { return }
                        let image = try? await todayModel.requestImage(fromUrlString: item.imageUrlString)
                        self.todayData[row].image = image
                    }
                case .watching:
                    break
                case .updates:
                    guard let item = updatesData[safe: row],
                            item.image == nil else {
                        return
                    }
                    Task { [weak self] in
                        guard let self else { return }
                        let image = try? await updatesModel.requestImage(fromUrlString: item.imageUrlString)
                        self.updatesData[row].image = image
                    }
                case .youtube:
                    guard let item = youtubeData[safe: row],
                            item.image == nil else {
                        return
                    }
                    Task { [weak self] in
                        guard let self else { return }
                        let image = try? await youtubeModel.requestImage(fromUrlString: item.imageUrlString)
                        self.youtubeData[row].image = image
                    }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cancelRequestImage(indexPath: indexPath)
        }
    }
}
