//
// SF Folders
// ButtonStyles.swift
//
// Created on 21/1/25
//
// Copyright ©2025 DoorHinge Apps.
//


import SwiftUI


struct Button3DStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            // Bottom shadow layer
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "4C7C97")) // Use the shadow color from your design
                .stroke(Color(hex: "4C7C97"), lineWidth: 4)
                .offset(y: 8)
                .shadow(color: Color(hex: "000000").opacity(0.3), radius: 6, x: 0, y: 4)

            // Main button background
            RoundedRectangle(cornerRadius: 12)
                .fill(configuration.isPressed ? Color(hex: "78D6FF") : Color(hex: "78D6FF")) // Main color with a pressed state
                .stroke(Color(hex: "1E8CCB"), lineWidth: 4)
                .offset(y: configuration.isPressed ? 8: 0)

            // Button label
            configuration.label
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .offset(y: configuration.isPressed ? 8: 0)
        }
        .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}


struct SmallButton3DStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            // Bottom shadow layer
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "4C7C97"))
                .stroke(Color(hex: "4C7C97"), lineWidth: 2)
                .offset(y: 4)
                .shadow(color: Color(hex: "000000").opacity(0.3), radius: 3, x: 0, y: 2)

            // Main button background
            RoundedRectangle(cornerRadius: 10)
                .fill(configuration.isPressed ? Color(hex: "78D6FF") : Color(hex: "78D6FF"))
                .stroke(Color(hex: "1E8CCB"), lineWidth: 2)
                .offset(y: configuration.isPressed ? 4: 0)

            // Button label
            configuration.label
                .font(.headline)
                .foregroundColor(.white)
                .offset(y: configuration.isPressed ? 4: 0)
        }
        .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
