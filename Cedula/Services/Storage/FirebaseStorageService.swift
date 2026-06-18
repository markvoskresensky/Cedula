//
//  FirebaseStorageService.swift
//  Cedula
//
//  Created by Marko on 18.06.2026.
//

import FirebaseStorage
import Foundation

@MainActor
final class FirebaseStorageService: StorageService {
    private let storage = Storage.storage()

    func uploadImage(_ data: Data, path: String) async throws -> String {
        let ref = storage.reference(withPath: path)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        _ = try await ref.putDataAsync(data, metadata: metadata)
        let url = try await ref.downloadURL()
        return url.absoluteString
    }
}
