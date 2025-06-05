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
            
            Text(.init("""
            **License**  
            This application is open source and distributed under the [Mozilla Public License 2.0](https://www.mozilla.org/en-US/MPL/2.0/).
            
            You can view the source code and license details on [GitHub](https://github.com/doorhinge-apps/SF-Symbols-Folders).
            """))
            .lineLimit(nil)

            Text(.init("[\(copyright)](https://doorhingeapps.com)"))
                .font(.footnote)
                .foregroundColor(.secondary)
                .underline(true)

            Spacer()
        }
        .frame(width: 400, height: 400)
        .padding()
    }
}
