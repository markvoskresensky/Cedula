# Cedula

Real-time chat app for iOS — SwiftUI + Firebase, with offline support.

## Features

- **Email/password authentication** (Firebase Auth) with sign in / sign up
- **Real-time messaging** — Firestore snapshot listeners, instant delivery
- **Offline-first** — Firestore on-device persistence: read history and queue outgoing messages without a connection
- **Message status** — sending / sent / read (double check), driven by write metadata
- **Read receipts** — recipients mark messages read; sender sees the status update live
- **Typing indicator** — "typing…" synced through the conversation document
- **Chat polish** — date separators (Today / Yesterday / date), avatars, timestamps
- **Image messages** — pick from Photos, upload to Firebase Storage, render inline*
- **Push notifications** — FCM client integration (token stored per user)*
- **Network status** — offline banner via `NWPathMonitor`
- **Localization** — English and Russian (String Catalog)
- **Light & dark mode** — semantic colors via a flexible theme

\* Image upload requires Cloud Storage enabled; push delivery requires a paid Apple Developer account (APNs) and a server / Cloud Function to send.

## Tech stack

- **SwiftUI**, iOS 26.5, Swift 5
- **Firebase** — Auth, Firestore, Storage, Cloud Messaging (via Swift Package Manager)
- **Swift Testing** for unit tests

## Architecture

MVVM with **enum-namespacing**. Each screen is its own `enum` namespace with three files under `Features/<Name>/`:

- `<Name>.swift` — namespace + `static func view()` factory
- `<Name>.Screen.swift` — `struct Screen: View`
- `<Name>.ViewModel.swift` — `@MainActor @Observable final class ViewModel`

Data access sits behind protocols (`AuthService`, `ChatService`, `UserService`, `StorageService`) so real Firebase implementations can be swapped for mocks in tests and previews. All services are created once in a single composition root (`Root.view()`) and injected down the view tree.

## Project structure

```
Cedula/
├─ CedulaApp.swift        // entry point → Root.view()
├─ AppDelegate.swift      // Firebase init, Firestore persistence, FCM
├─ Models/                // User, Conversation, Message, SampleData
├─ Services/              // Auth, Chat, User, Storage, Network — protocol + Firebase + Mock
├─ Features/              // Root, Login, ConversationList, Chat, NewChat
├─ DesignSystem/          // Theme + reusable components
└─ Localizable.xcstrings  // en + ru
```

## Getting started

### Requirements

- Xcode 26+, iOS 26.5 SDK
- A Firebase project (free Spark plan is enough to start)

### Firebase setup

1. Create a project in the [Firebase Console](https://console.firebase.google.com).
2. Register an iOS app with bundle id `com.marko.Cedula`.
3. Download `GoogleService-Info.plist` and add it to the `Cedula/` folder (it is git-ignored).
4. Enable **Authentication → Email/Password**.
5. Create a **Firestore Database** and apply security rules that restrict conversations and messages to their participants.
6. (Optional) Enable **Storage** for image messages and **Cloud Messaging** for push.

### Run

Open `Cedula.xcodeproj` in Xcode, select an iOS 26.5 simulator, and run. Firebase dependencies resolve automatically via SPM.

## Testing

View-model unit tests run against the mock services:

```bash
xcodebuild test -scheme Cedula -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

## Localization

UI strings use explicit identifier keys (e.g. `login_screen_name_field_title`) resolved through `Localizable.xcstrings`, with English and Russian translations. Add new visible strings to the catalog in both languages.
