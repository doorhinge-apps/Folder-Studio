//
// Icons Designer
// FolderPresetPreview.swift
//
// Created on 27/12/24
//
// Copyright ©2024 DoorHinge Apps.
//


import SwiftUI

struct FolderPresetPreview: View {
    @EnvironmentObject var foldersViewModel: FoldersViewModel
    
    @State var color1: String
    @State var color2: String

    var body: some View {
        ZStack {
            PresetFolderIconView(
                resolutionScale: 0.25,
                topShapeColor: .constant(Color(hex: color1)),
                bottomShapeColor: .constant(Color(hex: color2)),
                symbolColor: .constant(Color(hex: color1)),
                symbolOpacity: .constant(0.5)
            )
            .scaleEffect(0.15)
            .frame(width: 70, height: 60)
            .clipped()
            
            Color.gray.opacity(0.0001)
                .onTapGesture {
                    foldersViewModel.topShapeColor = Color(hex: color1)
                    foldersViewModel.symbolColor = Color(hex: color1)
                    foldersViewModel.bottomShapeColor = Color(hex: color2)
                    foldersViewModel.symbolOpacity = 0.5
                }
        }
    }
}

