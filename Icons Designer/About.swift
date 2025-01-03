//
// SF Folders
// About.swift
//
// Created on 3/1/25
//
// Copyright ©2025 DoorHinge Apps.
//


import SwiftUI

struct AboutView: View {
    var appName: String = "SF Symbols Folders"
    var appVersion: String = "Version 1.0.0"
    var copyright: String = "©2025 DoorHinge Apps"

    var body: some View {
        VStack(spacing: 16) {
            Image("Icon")
                .resizable()
                .frame(width: 100, height: 100)
                .padding()

            Text(appName)
                .font(.title)
                .bold()

            Text(appVersion)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(.init("This application is open source and licensed under the Mozilla Public License (MPL) 2.0. You can view the source code and license at [https://github.com/CaedmonMyers/SF-Symbols-Folders](https://github.com/CaedmonMyers/SF-Symbols-Folders)."))
                .lineLimit(nil)

            Text(copyright)
                .font(.footnote)
                .foregroundColor(.secondary)

            Button("Visit Website") {
                if let url = URL(string: "https://doorhingeapps.com") {
                    NSWorkspace.shared.open(url)
                }
            }
            .padding(.top)

            Spacer()
        }
        .frame(width: 400, height: 400)
        .padding()
    }
}
