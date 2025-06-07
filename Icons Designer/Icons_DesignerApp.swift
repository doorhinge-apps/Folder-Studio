//
// Icons Designer
// Icons_DesignerApp.swift
//
// Created on 27/12/24
//
// Copyright ©2024 DoorHinge Apps.
//


import SwiftUI

@main
struct Icons_DesignerApp: App {
    @State private var aboutWindow: NSWindow?
    
    @AppStorage("onboardingCompleted") var onboardingCompleted = false

    var body: some Scene {
        WindowGroup {
            EntryView()
                .containerBackground(for: .window, content: {
                    ZStack {
                        Color(hex: "6FCDF6")
                        
                        Image("grain")
                            .scaledToFill()
                    }.ignoresSafeArea()
                })
        }.windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button("about_menu_text") {
                    showAboutWindow()
                }
            }
            CommandGroup(after: .appInfo) {
                Divider()
                Button("Reset Onboarding") {
                    onboardingCompleted = false
                }
            }
        }
    }

    private func showAboutWindow() {
        if aboutWindow == nil {
            let aboutView = AboutView()
            aboutWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
                styleMask: [.titled, .closable],
                backing: .buffered, defer: false
            )
            aboutWindow?.contentView = NSHostingView(rootView: aboutView)
            aboutWindow?.title = NSLocalizedString("about_window_title", comment: "")
            aboutWindow?.isReleasedWhenClosed = false
            aboutWindow?.center()
        }
        aboutWindow?.makeKeyAndOrderFront(nil)
    }
}
