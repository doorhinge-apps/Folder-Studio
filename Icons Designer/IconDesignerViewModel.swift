import SwiftUI
import AppKit

class IconDesignerViewModel: ObservableObject {
    
    // MARK: - Published

    /// Colors for top shape and bottom shape
    @Published var topShapeColor: Color = Color(.darkGray)
    @Published var bottomShapeColor: Color = Color(.lightGray)
    
    /// The user-chosen offset for each shape
    @Published var bottomOffset: CGFloat = -112
    @Published var topOffset: CGFloat = 280

    @Published var symbolName: String = "star.fill"
    @Published var symbolColor: Color = .yellow

    /// New: Slider to change SF Symbol opacity (0.0–1.0)
    @Published var symbolOpacity: Double = 1.0
    
    // MARK: - Constants
    
    let finalSize = CGSize(width: 470, height: 395)
    let bottomRectSize = CGSize(width: 470, height: 328)
    let bottomRectCornerRadius: CGFloat = 35
    let topShapeSize = CGSize(width: 470, height: 114)
    
    // MARK: - Generate Final Icon
    
    func generateFinalIcon() -> NSImage? {
        
        // 1) Create NSBitmapImageRep
        guard let bitmapRep = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(finalSize.width),
            pixelsHigh: Int(finalSize.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .calibratedRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0
        ),
           let context = NSGraphicsContext(bitmapImageRep: bitmapRep)
        else { return nil }

        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = context

        // Clear background
        context.cgContext.setFillColor(NSColor.clear.cgColor)
        context.cgContext.fill(CGRect(origin: .zero, size: finalSize))

        // 2) Draw top shape (MyIcon)
        let topShapeRect = CGRect(
            x: 0,
            y: topOffset,
            width: topShapeSize.width,
            height: topShapeSize.height
        )
        context.cgContext.saveGState()

        // Flip vertically so MyIcon is oriented properly
        context.cgContext.translateBy(x: topShapeRect.minX, y: topShapeRect.minY)
        context.cgContext.scaleBy(x: 1, y: -1)
        context.cgContext.translateBy(x: 0, y: -topShapeSize.height)

        let iconPath = cgPathForMyIcon(size: topShapeSize)
        context.cgContext.addPath(iconPath)
        context.cgContext.setFillColor(topShapeColor.nsColor.cgColor)
        context.cgContext.fillPath()

        context.cgContext.restoreGState()

        // 3) Draw bottom rectangle
        let bottomY = 114 + bottomOffset
        let bottomRect = CGRect(
            x: 0,
            y: bottomY,
            width: bottomRectSize.width,
            height: bottomRectSize.height
        )
        let cornerPath = CGPath(
            roundedRect: bottomRect,
            cornerWidth: bottomRectCornerRadius,
            cornerHeight: bottomRectCornerRadius,
            transform: nil
        )
        context.cgContext.addPath(cornerPath)
        context.cgContext.setFillColor(bottomShapeColor.nsColor.cgColor)
        context.cgContext.fillPath()

        // 4) Finally, draw SF Symbol on top, centered in entire 470×395
        if let symbolImage = NSImage(systemSymbolName: symbolName, accessibilityDescription: nil) {
            let symbolSize = CGSize(width: 150, height: 150) // Or let user tweak
            // Colorize the symbol
            let coloredSymbol = NSImage(size: symbolSize)
            coloredSymbol.lockFocus()
            symbolColor.nsColor.set()
            NSGraphicsContext.current?.imageInterpolation = .high
            // Use .sourceAtop to fill symbol shape with symbolColor, fully
            symbolImage.draw(
                in: CGRect(origin: .zero, size: symbolSize),
                from: .zero,
                operation: .sourceAtop,
                fraction: 1.0
            )
            coloredSymbol.unlockFocus()
            
            // Center in entire final image
            let centerX = (finalSize.width - symbolSize.width) / 2
            let centerY = (finalSize.height - symbolSize.height) / 2
            coloredSymbol.draw(
                in: CGRect(origin: CGPoint(x: centerX, y: centerY), size: symbolSize),
                from: .zero,
                operation: .sourceOver, // default blend mode
                fraction: CGFloat(symbolOpacity) // user-controlled slider
            )
        }

        NSGraphicsContext.restoreGraphicsState()
        
        // Convert to NSImage
        let finalImage = NSImage(size: finalSize)
        finalImage.addRepresentation(bitmapRep)
        return finalImage
    }
    
    // MARK: - Save
    
    func saveFinalIcon(to url: URL) {
        guard let finalImage = generateFinalIcon(),
              let tiffData = finalImage.tiffRepresentation,
              let bitmapRep = NSBitmapImageRep(data: tiffData),
              let pngData = bitmapRep.representation(using: .png, properties: [:])
        else { return }
        
        do {
            try pngData.write(to: url)
        } catch {
            print("Error saving PNG: \(error)")
        }
    }
    
    // MARK: - MyIcon Helper
    
    func cgPathForMyIcon(size: CGSize) -> CGPath {
        let swiftUIPath = MyIcon().path(in: CGRect(origin: .zero, size: size))
        return swiftUIPath.cgPath
    }
}

// MARK: - Color Extension

extension Color {
    var nsColor: NSColor {
        NSColor(self)
    }
}
