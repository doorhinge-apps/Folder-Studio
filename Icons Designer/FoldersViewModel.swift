//
// SF Folders
// FoldersViewModel.swift
//
// Created on 3/6/25
//
// Copyright ©2025 DoorHinge Apps.
//


import SwiftUI

class FoldersViewModel: ObservableObject {
    // MARK: - Folder Colors
    @Published var topShapeColor: Color = Color(hex: "1E8CCB")
    @Published var bottomShapeColor: Color = Color(hex: "6FCDF6")
    
    // MARK: - Symbol Settings
    @Published var symbolColor: Color = Color(hex: "1E8CCB")
    @Published var symbolName: String = "star.fill"
    @Published var symbolOpacity: Double = 0.5
    
    // MARK: - App Settings & UI
    // For preset previews
    @Published var topOffset: CGFloat = -141
    @Published var bottomOffset: CGFloat = -81
    
    @Published var presets = [["1E8CCB", "6FCDF6"], ["D23359", "F66F8F"], ["DA8521", "F6B86F"], ["DCAE46", "F5DD62"], ["20731D", "43AC40"], ["2955AB", "5788E5"], ["7125BD", "A750FF"], ["BD2593", "FA62F4"]]
    
    @Published var dropError: String? = nil
    
    // MARK: - Random Booleans
    @Published var showIconPicker = false
    
    @Published var isTargetedDrop = false

    @Published var breatheAnimation = false
    @Published var rotateAnimation = false
    
    // MARK: - Customization Options
    @Published var imageType: ImageType = .sfsymbol
    
    @Published var iconOffset: CGFloat = 0
    @Published var plane2DTest: CGFloat = 0
    
    @Published var iconScale = 1.0
    
    @Published var selectedImage: NSImage? = nil
    
    @AppStorage("useAdvancedIconRendering") var useAdvancedIconRendering = true
    
    @Published var rotationAngle = 0
    
    @AppStorage("hideOpacity") var hideOpacity = false
    @AppStorage("hideScale") var hideScale = true
    @AppStorage("hideOffset") var hideOffset = true
}
