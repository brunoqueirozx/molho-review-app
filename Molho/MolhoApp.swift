//
//  MolhoApp.swift
//  Molho
//
//  Created by Bruno Queiroz on 06/11/25.
//

import SwiftUI

@main
struct MolhoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
