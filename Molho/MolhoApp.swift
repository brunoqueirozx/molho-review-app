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
    @StateObject private var authManager = AuthenticationManager.shared

    var body: some Scene {
        WindowGroup {
            Group {
                if authManager.isLoading {
                    // Splash screen enquanto verifica autenticação
                    SplashView()
                } else if authManager.isAuthenticated {
                    // Usuário autenticado - mostra app principal
                    HomeView()
                } else {
                    // Usuário não autenticado - mostra tela de login
                    AuthenticationView()
                }
            }
            .environmentObject(authManager)
        }
    }
}
