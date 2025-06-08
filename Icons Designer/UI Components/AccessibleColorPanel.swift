//
// SF Folders
// AccessibleColorPanel.swift
//
// Created on 7/6/25
//
// Copyright ©2025 DoorHinge Apps.
//


import SwiftUI

struct AccessibleColorWell: NSViewRepresentable {
    @Binding var color: Color

    func makeNSView(context: Context) -> NSButton {
        let button = NSButton()
        button.title = ""
        button.isBordered = false
        button.setButtonType(.momentaryChange)
        button.bezelStyle = .regularSquare
        button.imagePosition = .imageOnly
        button.focusRingType = .none
        button.wantsLayer = true
        button.layer?.cornerRadius = 4
        button.layer?.borderWidth = 1
        button.layer?.borderColor = NSColor.separatorColor.cgColor
        button.target = context.coordinator
        button.action = #selector(Coordinator.openColorPanel)

        button.setAccessibilityElement(true)
        button.setAccessibilityRole(.button)
        button.setAccessibilityLabel("Select Color")

        return button
    }

    func updateNSView(_ nsView: NSButton, context: Context) {
        let nsColor = NSColor(color)
        nsView.layer?.backgroundColor = nsColor.cgColor
        nsView.setAccessibilityValue(nsColor.accessibilityName ?? "accessibility_custom_color_label_fallback")
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(color: $color)
    }

    class Coordinator: NSObject {
        var color: Binding<Color>

        init(color: Binding<Color>) {
            self.color = color
        }

        @objc func openColorPanel() {
            let panel = NSColorPanel.shared
            panel.setTarget(self)
            panel.setAction(#selector(colorDidChange(_:)))
            panel.color = NSColor(color.wrappedValue)
            panel.makeKeyAndOrderFront(nil)
        }

        @objc func colorDidChange(_ sender: NSColorPanel) {
            color.wrappedValue = Color(nsColor: sender.color)
        }
    }
}
