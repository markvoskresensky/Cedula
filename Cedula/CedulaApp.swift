//
//  CedulaApp.swift
//  Cedula
//
//  Created by Marko on 16.06.2026.
//

import SwiftUI

@main
struct CedulaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            ConversationList.view()
        }
    }
}
