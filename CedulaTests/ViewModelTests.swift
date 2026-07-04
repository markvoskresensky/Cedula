//
//  ViewModelTests.swift
//  CedulaTests
//
//  Created by Marko on 18.06.2026.
//

import Foundation
import Testing
@testable import Cedula

// MARK: - Helpers

@MainActor
private final class ThrowingAuthService: AuthService {
    struct Failure: Error {}

    var currentUser: User?

    func authState() -> AsyncStream<User?> {
        AsyncStream { $0.finish() }
    }

    func signIn(email: String, password: String) async throws {
        throw Failure()
    }

    func signUp(displayName: String, email: String, password: String) async throws {
        throw Failure()
    }

    func signOut() throws {}
}

private func message(_ id: String, sender: String, daysAgo: Int, text: String = "hi") -> Message {
    Message(
        id: id,
        conversationID: "c",
        senderID: sender,
        text: text,
        imageURL: nil,
        sentAt: Calendar.current.date(byAdding: .day, value: -daysAgo, to: .now) ?? .now,
        status: .sent
    )
}

// MARK: - Login

@MainActor
@Test func loginCanSubmitRules() {
    let model = Login.ViewModel(authService: MockAuthService(), userService: MockUserService())
    #expect(model.canSubmit == false)

    model.email = "a@b.com"
    model.password = "12345"
    #expect(model.canSubmit == false) // password < 6

    model.password = "123456"
    #expect(model.canSubmit == true) // sign in mode

    model.mode = .signUp
    #expect(model.canSubmit == false) // name required

    model.displayName = "Alice"
    #expect(model.canSubmit == true)
}

@MainActor
@Test func loginToggleModeClearsError() {
    let model = Login.ViewModel(authService: MockAuthService(), userService: MockUserService())
    #expect(model.mode == .signIn)
    model.toggleMode()
    #expect(model.mode == .signUp)
    model.toggleMode()
    #expect(model.mode == .signIn)
}

@MainActor
@Test func loginSignInSuccess() async {
    let auth = MockAuthService()
    let model = Login.ViewModel(authService: auth, userService: MockUserService())
    model.email = "a@b.com"
    model.password = "123456"
    await model.submit()
    #expect(auth.currentUser != nil)
    #expect(model.errorMessage == nil)
}

@MainActor
@Test func loginSubmitFailureSetsError() async {
    let model = Login.ViewModel(authService: ThrowingAuthService(), userService: MockUserService())
    model.email = "a@b.com"
    model.password = "123456"
    await model.submit()
    #expect(model.errorMessage != nil)
}

@MainActor
@Test func loginSignUpUpsertsProfile() async throws {
    let auth = MockAuthService()
    let users = MockUserService(users: [])
    let model = Login.ViewModel(authService: auth, userService: users)
    model.mode = .signUp
    model.displayName = "New User"
    model.email = "new@b.com"
    model.password = "123456"
    await model.submit()

    let stored = try await users.others(excluding: "someone-else")
    #expect(stored.contains { $0.id == auth.currentUser?.id })
}

// MARK: - ConversationList

@MainActor
@Test func conversationListSignOut() {
    let auth = MockAuthService(currentUser: SampleData.currentUser)
    let model = ConversationList.ViewModel(
        chatService: MockChatService(),
        userService: MockUserService(),
        authService: auth,
        storageService: MockStorageService()
    )
    #expect(auth.currentUser != nil)
    model.signOut()
    #expect(auth.currentUser == nil)
}

@MainActor
@Test func conversationListCurrentUserFallback() {
    let model = ConversationList.ViewModel(
        chatService: MockChatService(),
        userService: MockUserService(),
        authService: MockAuthService(currentUser: nil),
        storageService: MockStorageService()
    )
    #expect(model.currentUser.id == SampleData.currentUser.id)
}

// MARK: - Chat

@MainActor
@Test func chatIsOutgoing() {
    let model = Chat.ViewModel(
        conversationID: "c",
        title: "T",
        currentUserID: "me",
        chatService: MockChatService(),
        storageService: MockStorageService()
    )
    #expect(model.isOutgoing(message("1", sender: "me", daysAgo: 0)) == true)
    #expect(model.isOutgoing(message("2", sender: "other", daysAgo: 0)) == false)
}

@MainActor
@Test func chatSendAppendsMessage() async {
    let mock = MockChatService(messages: ["c": []], conversations: [])
    let model = Chat.ViewModel(
        conversationID: "c",
        title: "T",
        currentUserID: "me",
        chatService: mock,
        storageService: MockStorageService()
    )
    model.draft = "Hello"
    await model.send()

    var iterator = mock.messages(in: "c").makeAsyncIterator()
    let messages = await iterator.next()
    #expect(messages?.contains { $0.text == "Hello" && $0.senderID == "me" } == true)
}

@MainActor
@Test func chatDayGroupsGroupByDay() {
    let messages = [
        message("1", sender: "me", daysAgo: 1),
        message("2", sender: "me", daysAgo: 1),
        message("3", sender: "me", daysAgo: 0),
    ]
    let groups = Chat.ViewModel.dayGroups(from: messages)
    #expect(groups.count == 2)
    #expect(groups.first?.messages.count == 2) // older day first
    #expect(groups.last?.messages.count == 1)
}

// MARK: - NewChat

@MainActor
@Test func newChatLoadsOthers() async {
    let model = NewChat.ViewModel(
        currentUser: SampleData.currentUser,
        chatService: MockChatService(),
        userService: MockUserService(users: [SampleData.alice, SampleData.bob])
    )
    await model.load()
    if case let .loaded(users) = model.state {
        #expect(users.count == 2)
    } else {
        Issue.record("Expected .loaded state")
    }
}

@MainActor
@Test func newChatStartChatCreatesConversation() async {
    let mock = MockChatService()
    let initialCount = SampleData.conversations.count
    let model = NewChat.ViewModel(
        currentUser: SampleData.currentUser,
        chatService: mock,
        userService: MockUserService()
    )
    await model.startChat(with: SampleData.alice)

    var iterator = mock.conversations(for: SampleData.currentUser.id).makeAsyncIterator()
    let conversations = await iterator.next()
    #expect(conversations?.count == initialCount + 1)
}
