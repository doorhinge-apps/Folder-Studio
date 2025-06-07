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
    var appName: LocalizedStringKey = "app_name"
    var appVersion: LocalizedStringKey = "Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.1")"
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
            
            Text("license_details")
            .lineLimit(nil)

            Text("[\(copyright)](https://doorhingeapps.com)")
                .font(.footnote)
                .foregroundColor(.secondary)
                .underline(true)

            Spacer()
        }
        .frame(width: 400, height: 400)
        .padding()
    }
}
