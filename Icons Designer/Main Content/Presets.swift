//
// SF Folders
// Presets.swift
//
// Created on 7/6/25
//
// Copyright ©2025 DoorHinge Apps.
//


import SwiftUI

struct Presets: View {
    @EnvironmentObject var foldersViewModel: FoldersViewModel
    
    var body: some View {
        HStack {
            Text("preset_label_text")
                .font(.system(.title, design: .rounded, weight: .bold))
                .rotationEffect(Angle(degrees: -90))
                .foregroundStyle(Color.white)
                .frame(width: 200, height: 20)
                .accessibilityHidden(true)
        }.frame(width: 10)
            .offset(x: -10)
        
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                ForEach(foldersViewModel.presets, id: \.self) { preset in
                    FolderPresetPreview(color1: preset[0], color2: preset[1])
                }
                Spacer().frame(height: 50)
            }
        }
        .accessibilityElement()
        .accessibilityLabel("accessibility_color_presets_label")
        .accessibilityActions {
            let reorderedIndices = [6, 5, 4, 3, 2, 1, 0, 7] // Maps to your desired 1,2,3,4,5,6,7,8 order
            ForEach(reorderedIndices, id: \.self) { originalIndex in
                let preset = foldersViewModel.presets[originalIndex]
                Button(foldersViewModel.presetLabels[preset[0]] ?? "accessibility_preset_label_default \(originalIndex + 1)") {
                    foldersViewModel.topShapeColor = Color(hex: preset[0])
                    foldersViewModel.symbolColor = Color(hex: preset[0])
                    foldersViewModel.bottomShapeColor = Color(hex: preset[1])
                    foldersViewModel.symbolOpacity = 0.5
                }
            }
        }
        .frame(width: 80)
        //.offset(x: -5)
    }
}
