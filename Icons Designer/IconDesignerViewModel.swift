import SwiftUI
import Combine
import PocketSVG
import AppKit

class IconDesignerViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var paths: [NSBezierPath] = []
    
    /// Colors for top shape and bottom shape
    @Published var topShapeColor: Color = Color(.darkGray)
    @Published var bottomShapeColor: Color = Color(.lightGray)
    
    /// The user-chosen offset for each shape
    @Published var bottomOffset: CGFloat = 0
    @Published var topOffset: CGFloat = 0
    
    /// Final icon dimensions
    let finalSize = CGSize(width: 470, height: 395)
    
    /// Bottom rectangle: 470×328 with corner radius = 35
    let bottomRectSize = CGSize(width: 470, height: 328)
    let bottomRectCornerRadius: CGFloat = 35
    
    /// Top shape: 470×114
    let topShapeSize = CGSize(width: 470, height: 114)
    
    // MARK: - Load SVG
    
    /// Load an SVG file and parse it into an array of NSBezierPaths.
    func loadSVG(from url: URL) {
        let loadedPaths = SVGBezierPath.pathsFromSVG(at: url)
        if !loadedPaths.isEmpty {
            self.paths = loadedPaths
        } else {
            print("No paths found or failed to parse.")
            self.paths = []
        }
    }
    
    // MARK: - Generate Final Icon
    
    /// Generates the final 470×395 folder icon as an NSImage.
    func generateFinalIcon() -> NSImage? {
        // Create a bitmap context
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
        ) else {
            return nil
        }
        
        guard let context = NSGraphicsContext(bitmapImageRep: bitmapRep) else {
            return nil
        }
        
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = context
        
        // Clear background
        context.cgContext.setFillColor(NSColor.clear.cgColor)
        context.cgContext.fill(CGRect(origin: .zero, size: finalSize))
        
        // 1) Draw top shape
        let topShapeRect = CGRect(
            x: 0,
            y: topOffset,
            width: topShapeSize.width,
            height: topShapeSize.height
        )
        context.cgContext.setFillColor(topShapeColor.nsColor.cgColor)
        context.cgContext.fill(topShapeRect)
        
        // 2) Draw bottom rectangle with rounded corners (radius = 35)
        let bottomY = CGFloat(114) + bottomOffset
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
        
        // 3) Draw SVG paths in white, scaled & flipped
        if !paths.isEmpty {
            let allBounds = unionOfAllBounds(paths: paths)
            
            // Step A: Compute scale to fit within 300x230
            let maxTargetSize = CGSize(width: 300, height: 230)
            let scaleClamp = transformToFit(
                sourceBounds: allBounds,
                destination: CGRect(origin: .zero, size: maxTargetSize)
            )
            
            // Step B: Flip vertically
            let flipped = CGAffineTransform(translationX: 0, y: allBounds.height)
                .scaledBy(x: 1, y: -1)
            
            // Combine: scale then flip
            let finalTransform = flipped.concatenating(scaleClamp)
            
            // Step C: Center the SVG within the bottomRect
            let transformedSize = applyTransformToSize(allBounds.size, finalTransform)
            let dx = (bottomRect.width - transformedSize.width) / 2 - (allBounds.minX * scaleClamp.a)
            let dy = (bottomRect.height - transformedSize.height) / 2 - (allBounds.minY * scaleClamp.d)
            let translationToCenter = CGAffineTransform(translationX: dx, y: dy)
            
            let transform = translationToCenter.concatenating(finalTransform)
            
            context.cgContext.saveGState()
            context.cgContext.concatenate(transform)
            
            // Fill each path in white
            for path in paths {
                let cgPath = path.cgPath
                context.cgContext.addPath(cgPath)
                context.cgContext.setFillColor(NSColor.white.cgColor)
                context.cgContext.fillPath()
            }
            
            context.cgContext.restoreGState()
        }
        
        NSGraphicsContext.restoreGraphicsState()
        
        // Convert bitmap to NSImage
        let finalImage = NSImage(size: finalSize)
        finalImage.addRepresentation(bitmapRep)
        return finalImage
    }
    
    // MARK: - Save as PNG
    
    /// Saves the final icon as a PNG file to the specified URL.
    func saveFinalIcon(to url: URL) {
        guard
            let finalImage = generateFinalIcon(),
            let tiffData = finalImage.tiffRepresentation,
            let bitmapRep = NSBitmapImageRep(data: tiffData),
            let pngData = bitmapRep.representation(using: .png, properties: [:])
        else {
            print("Failed to generate PNG data.")
            return
        }
        
        do {
            try pngData.write(to: url)
            print("Saved icon to \(url.path)")
        } catch {
            print("Error saving PNG: \(error)")
        }
    }
    
    // MARK: - Helper Functions
    
    /// Combines all bounding boxes of the paths into one CGRect.
    private func unionOfAllBounds(paths: [NSBezierPath]) -> CGRect {
        var unionRect = CGRect.null
        for p in paths {
            unionRect = unionRect.union(p.bounds)
        }
        return unionRect
    }
    
    /// Creates a transform that fits `sourceBounds` into `destination` proportionally (aspect fit).
    private func transformToFit(sourceBounds: CGRect, destination: CGRect) -> CGAffineTransform {
        let srcAspect = sourceBounds.width / sourceBounds.height
        let dstAspect = destination.width / destination.height
        
        var scale: CGFloat = 1.0
        var dx: CGFloat = 0
        var dy: CGFloat = 0
        
        if srcAspect > dstAspect {
            // Source is wider relative to destination
            scale = destination.width / sourceBounds.width
            let scaledHeight = sourceBounds.height * scale
            dy = (destination.height - scaledHeight) / 2 - sourceBounds.minY * scale
            dx = -sourceBounds.minX * scale
        } else {
            // Source is taller relative to destination
            scale = destination.height / sourceBounds.height
            let scaledWidth = sourceBounds.width * scale
            dx = (destination.width - scaledWidth) / 2 - sourceBounds.minX * scale
            dy = -sourceBounds.minY * scale
        }
        
        return CGAffineTransform(translationX: dx, y: dy).scaledBy(x: scale, y: scale)
    }
    
    /// Applies an affine transform to a size and returns the resulting CGSize.
    private func applyTransformToSize(_ size: CGSize, _ transform: CGAffineTransform) -> CGSize {
        let p1 = CGPoint(x: 0, y: 0).applying(transform)
        let p2 = CGPoint(x: size.width, y: size.height).applying(transform)
        return CGSize(width: abs(p2.x - p1.x), height: abs(p2.y - p1.y))
    }
}

// MARK: - Color Extension

extension Color {
    var nsColor: NSColor {
        NSColor(self)
    }
}
