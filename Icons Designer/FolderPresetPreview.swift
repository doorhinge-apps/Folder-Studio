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
    @State var color1: String
    @State var color2: String
    
    @Binding var symbolName: String
    @Binding var topOffset: CGFloat
    @Binding var bottomOffset: CGFloat
    
    @Binding var topShapeColorSetter: Color
    @Binding var bottomShapeColorSetter: Color
    @Binding var iconColorSetter: Color
    @Binding var opacitySetter: Double
    
    @Binding var iconScale: Double
    
    @Binding var selectedImage: NSImage?
    var body: some View {
        ZStack {
            FolderIconView(topShapeColor: .constant(Color(hex: color1)),
                           bottomShapeColor: .constant(Color(hex: color2)),
                           symbolName: $symbolName,
                           symbolColor: .constant(Color(hex: color1)),
                           symbolOpacity: .constant(0.5),
                           topOffset: $topOffset,
                           bottomOffset: $bottomOffset,
                           iconOffset: .constant(0),
                           iconScale: .constant(1),
                           imageType: .constant(.sfsymbol),
                           customImage: $selectedImage,
                           useAdvancedIconRendering: .constant(false),
                           resolutionScale: 0.25
            )
            .scaleEffect(0.15)
            .frame(width: 70, height: 60)
            .clipped()
            
            Color.gray.opacity(0.0001)
                .onTapGesture {
                    topShapeColorSetter = Color(hex: color1)
                    iconColorSetter = Color(hex: color1)
                    bottomShapeColorSetter = Color(hex: color2)
                    opacitySetter = 0.5
//                    iconScale = 1
                }
        }
    }
}

