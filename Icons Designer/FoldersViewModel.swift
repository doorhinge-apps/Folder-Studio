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
    
    @Published var symbolWeight: Double = 4.0
    
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
    @Published var iconOffsetX: CGFloat = 0
    @Published var plane2DTest: CGFloat = 0
    
    @Published var iconScale = 1.0
    
    @Published var selectedImage: NSImage? = nil
    
    @AppStorage("useAdvancedIconRendering") var useAdvancedIconRendering = true
    
    @Published var rotationAngle = 0
    
    @AppStorage("hideOpacity") var hideOpacity = false
    @AppStorage("hideScale") var hideScale = false
    @AppStorage("hideOffset") var hideOffset = false
    @AppStorage("hideWeight") var hideWeight = false

    /// Creates a synchronously processed image matching the advanced rendering
    /// mode. This is used when exporting icons so that the snapshot reflects
    /// the final tinted image without waiting for asynchronous tasks.
    func preRenderedImage() -> NSImage? {
        guard useAdvancedIconRendering,
              imageType == .png,
              let image = selectedImage else { return nil }

        return Self.grayscaleMappedImage(from: image, tint: NSColor(symbolColor))
    }

    private static func grayscaleMappedImage(from original: NSImage, tint baseColor: NSColor) -> NSImage? {
        guard let tiff = original.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiff),
              let cgImage = bitmap.cgImage else { return nil }

        let width = cgImage.width
        let height = cgImage.height

        guard let context = CGContext(data: nil,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: width * 4,
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        else { return nil }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        guard let buffer = context.data else { return nil }
        let ptr = buffer.bindMemory(to: UInt8.self, capacity: width * height * 4)

        let baseR = baseColor.redComponent
        let baseG = baseColor.greenComponent
        let baseB = baseColor.blueComponent

        let minC: CGFloat = 0.10
        let maxC: CGFloat = 0.90
        let whiteCutoff = 0.90

        for i in 0..<(width * height) {
            let o = i * 4
            let originalAlpha = ptr[o + 3]
            if originalAlpha == 0 { continue }

            let r = Double(ptr[o])
            let g = Double(ptr[o + 1])
            let b = Double(ptr[o + 2])
            let gray = (0.299*r + 0.587*g + 0.114*b) / 255.0

            if gray > whiteCutoff {
                ptr[o + 3] = 0
                continue
            }

            let delta = max(min((gray - 0.5) / 0.25, 1.0), -1.0)
            let scale: CGFloat = 0.25

            var outR = baseR + delta * scale * (1 - baseR)
            var outG = baseG + delta * scale * (1 - baseG)
            var outB = baseB + delta * scale * (1 - baseB)

            outR = clamp(outR, minC, maxC)
            outG = clamp(outG, minC, maxC)
            outB = clamp(outB, minC, maxC)

            ptr[o]     = UInt8(outR * 255)
            ptr[o + 1] = UInt8(outG * 255)
            ptr[o + 2] = UInt8(outB * 255)
            ptr[o + 3] = originalAlpha
        }

        guard let outputCG = context.makeImage() else { return nil }
        return NSImage(cgImage: outputCG, size: NSSize(width: width, height: height))
    }

    private static func clamp<T: Comparable>(_ val: T, _ min: T, _ max: T) -> T {
        Swift.max(min, Swift.min(max, val))
    }
}
