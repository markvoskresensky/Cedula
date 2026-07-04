//
//  MockStorageService.swift
//  Cedula
//
//  Created by Marko on 18.06.2026.
//

import Foundation

@MainActor
final class MockStorageService: StorageService {
    func uploadImage(_ data: Data, path: String) async throws -> String {
        "https://example.com/\(path)"
    }
}
