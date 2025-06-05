//
// SF Folders
// EntryView.swift
//
// Created on 5/6/25
//
// Copyright ©2025 DoorHinge Apps.
//


import SwiftUI

struct EntryView: View {
    @StateObject var foldersViewModel = FoldersViewModel()
    var body: some View {
        ContentView()
            .environmentObject(foldersViewModel)
    }
}

