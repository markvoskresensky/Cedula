//
//  StorageService.swift
//  Cedula
//
//  Created by Marko on 18.06.2026.
//

import Foundation

@MainActor
protocol StorageService {
    func uploadImage(_ data: Data, path: String) async throws -> String
}
