//
//  NetworkMonitor.swift
//  Cedula
//
//  Created by Marko on 18.06.2026.
//

import Network
import Observation

@MainActor
@Observable
final class NetworkMonitor {
    private(set) var isConnected = true

    private let monitor = NWPathMonitor()

    init() {
        let monitor = monitor
        let stream = AsyncStream<Bool> { continuation in
            monitor.pathUpdateHandler = { path in
                continuation.yield(path.status == .satisfied)
            }
            monitor.start(queue: DispatchQueue(label: "com.marko.Cedula.networkmonitor"))
        }
        Task { [weak self] in
            for await connected in stream {
                self?.isConnected = connected
            }
        }
    }
}
