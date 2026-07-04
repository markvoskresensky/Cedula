//
//  AppDelegate.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseMessaging
import UIKit
import UserNotifications

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        configureFirestore()
        configurePushNotifications(application)
        return true
    }

    private func configureFirestore() {
        let settings = FirestoreSettings()
        settings.cacheSettings = PersistentCacheSettings()
        Firestore.firestore().settings = settings
    }

    private func configurePushNotifications(_ application: UIApplication) {
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self

        Task {
            let granted = (try? await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound])) ?? false
            guard granted else { return }
            await MainActor.run { application.registerForRemoteNotifications() }
        }

        // Save the FCM token whenever a user signs in (token may arrive before sign-in).
        _ = Auth.auth().addStateDidChangeListener { _, user in
            guard let uid = user?.uid else { return }
            Task { @MainActor in
                guard let token = try? await Messaging.messaging().token() else { return }
                await FirestoreUserService().addFCMToken(token, for: uid)
            }
        }
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken, let uid = Auth.auth().currentUser?.uid else { return }
        Task { @MainActor in
            await FirestoreUserService().addFCMToken(fcmToken, for: uid)
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .badge, .sound]
    }
}
