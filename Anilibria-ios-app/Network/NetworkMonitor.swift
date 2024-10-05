//
//  NetworkMonitor.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 07.02.2023.
//

import Foundation
import Network
import Combine

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue(label: "com.anilibria.networkMonitorQueue")
    private let monitor = NWPathMonitor()
    
    var isConnectedPublisher: AnyPublisher<Bool, Never> {
        isConnectedSubject
            .eraseToAnyPublisher()
    }
    
    private let isConnectedSubject = PassthroughSubject<Bool, Never>()
    
    private(set) var isConnected: Bool = true {
        didSet {
            isConnectedSubject.send(isConnected)
        }
    }
    private(set) var connectionType: ConnectionType = .unknown
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    private init() { }
    
    private func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
    }
}

// MARK: - Internal methods

extension NetworkMonitor {
    func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            self?.getConnectionType(path)
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
