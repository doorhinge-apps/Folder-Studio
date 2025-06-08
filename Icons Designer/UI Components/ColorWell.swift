//
// SF Folders
// ColorWell.swift
//
// Created on 1/4/25
//
// Copyright ©2025 DoorHinge Apps.
//


import SwiftUI
import AppKit
import Combine

struct ColorWell: NSViewRepresentable {
    @Binding var color: Color
    
    func makeNSView(context: Context) -> NSColorWell {
        let colorWell = NSColorWell(style: .minimal)
        colorWell.color = NSColor(color)
        
        colorWell.setAccessibilityElement(true)
        colorWell.setAccessibilityLabel("accessibility_color_picker_label_generic")
        colorWell.setAccessibilityHelp("accessibility_color_picker_popover_description")
        colorWell.setAccessibilityRole(.colorWell)
        colorWell.setAccessibilityEnabled(true)

        context.coordinator.startObservingColorChange(of: colorWell)
        return colorWell
    }

    
    func updateNSView(_ nsView: NSColorWell, context: Context) {
        nsView.color = NSColor(color)
        context.coordinator.colorDidChange = {
            color = Color(nsColor: $0)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    @MainActor
    class Coordinator: NSObject {
        var colorDidChange: ((NSColor) -> Void)?
        
        private var cancellable: AnyCancellable?
        
        func startObservingColorChange(of colorWell: NSColorWell) {
            cancellable = colorWell.publisher(for: \.color).sink { [weak self] in
                self?.colorDidChange?($0)
            }
        }
    }
}


extension Color {
    var accessibilityName: String {
        if self == .red { return NSLocalizedString("red_label", comment: "Color red") }
        if self == .blue { return NSLocalizedString("blue_label", comment: "Color blue") }
        if self == .green { return NSLocalizedString("green_label", comment: "Color green") }
        if self == .black { return NSLocalizedString("black_label", comment: "Color black") }
        if self == .white { return NSLocalizedString("white_label", comment: "Color white") }

        if let nsColor = NSColor(self).usingColorSpace(.deviceRGB) {
            let r = Int(nsColor.redComponent * 255)
            let g = Int(nsColor.greenComponent * 255)
            let b = Int(nsColor.blueComponent * 255)

            let format = NSLocalizedString("accessibility_custom_color_text", comment: "Custom color RGB description, e.g., Red %d, Green %d, Blue %d")
            return String(format: format, r, g, b)
        }

        return NSLocalizedString("accessibility_custom_color_text", comment: "Generic fallback for custom color")
    }
}

