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
