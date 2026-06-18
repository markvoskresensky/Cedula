//
//  FirestoreChatService.swift
//  Cedula
//
//  Created by Marko on 18.06.2026.
//

import FirebaseFirestore
import Foundation

@MainActor
final class FirestoreChatService: ChatService {
    private let db = Firestore.firestore()

    func conversations(for userID: String) -> AsyncStream<[Conversation]> {
        AsyncStream { continuation in
            nonisolated(unsafe) let listener = db.collection("conversations")
                .whereField("participantIDs", arrayContains: userID)
                .addSnapshotListener { snapshot, _ in
                    let items = (snapshot?.documents.compactMap {
                        Self.conversation(from: $0, currentUserID: userID)
                    } ?? [])
                    .sorted { $0.lastMessageDate > $1.lastMessageDate }
                    continuation.yield(items)
                }
            continuation.onTermination = { _ in listener.remove() }
        }
    }

    func messages(in conversationID: String) -> AsyncStream<[Message]> {
        AsyncStream { continuation in
            nonisolated(unsafe) let listener = db.collection("conversations")
                .document(conversationID)
                .collection("messages")
                .order(by: "sentAt")
                .addSnapshotListener { snapshot, _ in
                    let items = snapshot?.documents.compactMap {
                        Self.message(from: $0, conversationID: conversationID)
                    } ?? []
                    continuation.yield(items)
                }
            continuation.onTermination = { _ in listener.remove() }
        }
    }

    func send(text: String, to conversationID: String, from senderID: String) async throws {
        let conversationRef = db.collection("conversations").document(conversationID)
        let messageRef = conversationRef.collection("messages").document()
        let now = Date()

        let batch = db.batch()
        batch.setData(
            [
                "senderID": senderID,
                "text": text,
                "sentAt": Timestamp(date: now),
                "status": Message.Status.sent.rawValue,
            ],
            forDocument: messageRef
        )
        batch.updateData(
            [
                "lastMessageText": text,
                "lastMessageDate": Timestamp(date: now),
            ],
            forDocument: conversationRef
        )
        try await batch.commit()
    }

    func createConversation(participants: [User]) async throws -> String {
        let ref = db.collection("conversations").document()
        var participantNames: [String: String] = [:]
        for participant in participants {
            participantNames[participant.id] = participant.displayName
        }
        try await ref.setData([
            "participantIDs": participants.map(\.id),
            "participantNames": participantNames,
            "lastMessageText": "",
            "lastMessageDate": Timestamp(date: Date()),
        ])
        return ref.documentID
    }

    private static func conversation(from document: QueryDocumentSnapshot, currentUserID: String) -> Conversation? {
        let data = document.data()
        guard let participantIDs = data["participantIDs"] as? [String] else { return nil }
        let names = data["participantNames"] as? [String: String] ?? [:]
        let otherID = participantIDs.first { $0 != currentUserID }
        let title = otherID.flatMap { names[$0] } ?? names.values.first ?? "Chat"
        let lastMessageText = data["lastMessageText"] as? String ?? ""
        let lastMessageDate = (data["lastMessageDate"] as? Timestamp)?.dateValue() ?? Date()
        return Conversation(
            id: document.documentID,
            title: title,
            participantIDs: participantIDs,
            lastMessageText: lastMessageText,
            lastMessageDate: lastMessageDate,
            unreadCount: 0
        )
    }

    private static func message(from document: QueryDocumentSnapshot, conversationID: String) -> Message? {
        let data = document.data()
        guard let senderID = data["senderID"] as? String, let text = data["text"] as? String else {
            return nil
        }
        let sentAt = (data["sentAt"] as? Timestamp)?.dateValue() ?? Date()
        let status = Message.Status(rawValue: data["status"] as? String ?? "") ?? .sent
        return Message(
            id: document.documentID,
            conversationID: conversationID,
            senderID: senderID,
            text: text,
            sentAt: sentAt,
            status: status
        )
    }
}
