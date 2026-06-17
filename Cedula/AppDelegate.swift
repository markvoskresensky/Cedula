//
//  AppDelegate.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import FirebaseCore
import FirebaseFirestore
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        configureFirestore()
        return true
    }

    private func configureFirestore() {
        let settings = FirestoreSettings()
        settings.cacheSettings = PersistentCacheSettings()
        Firestore.firestore().settings = settings
    }
}
