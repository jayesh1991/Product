//
//  Reachability.swift
//  Poc
//
//  Created by jayesh rajput on 14/04/25.
//

import Foundation
import Network

class Reachability {
    static let shared = Reachability()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "ReachabilityMonitor")

    private(set) var isConnected: Bool = true

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = (path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }
}
