//
//  FirestoreUserService.swift
//  Cedula
//
//  Created by Marko on 18.06.2026.
//

import FirebaseFirestore
import Foundation

@MainActor
final class FirestoreUserService: UserService {
    private let db = Firestore.firestore()

    func upsert(_ user: User) async throws {
        try await db.collection("users").document(user.id).setData(
            [
                "displayName": user.displayName,
                "email": user.email ?? "",
            ],
            merge: true
        )
    }

    func addFCMToken(_ token: String, for userID: String) async {
        try? await db.collection("users").document(userID).setData(
            ["fcmTokens": FieldValue.arrayUnion([token])],
            merge: true
        )
    }

    func others(excluding userID: String) async throws -> [User] {
        let snapshot = try await db.collection("users").getDocuments()
        return snapshot.documents.compactMap { document in
            guard document.documentID != userID else { return nil }
            let data = document.data()
            let email = data["email"] as? String
            let displayName = data["displayName"] as? String ?? email ?? "User"
            return User(id: document.documentID, displayName: displayName, email: email, avatarName: nil)
        }
    }
}
