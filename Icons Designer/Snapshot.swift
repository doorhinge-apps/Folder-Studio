import SwiftUI

#if os(macOS)
extension View {
    /// Renders this SwiftUI view into an `NSImage`.
    func snapshotAsNSImage() -> NSImage {
        // Use an NSHostingController to render the SwiftUI view offscreen
        let controller = NSHostingController(rootView: self)
        
        // Size the view to its ideal size (or a fixed size if known)
        let targetSize = controller.sizeThatFits(in: NSSize(width: 10000, height: 10000))
        controller.view.frame = NSRect(origin: .zero, size: targetSize)

        // Render the view into a bitmap
        let bitmapRep = controller.view.bitmapImageRepForCachingDisplay(in: controller.view.bounds)!
        controller.view.cacheDisplay(in: controller.view.bounds, to: bitmapRep)
        
        // Convert the bitmap into an NSImage
        let nsImage = NSImage(size: targetSize)
        nsImage.addRepresentation(bitmapRep)
        return nsImage
    }
}
#else
extension View {
    /// Renders this SwiftUI view into a `UIImage`.
    func snapshotAsUIImage() -> UIImage {
        // Use a UIHostingController to render the SwiftUI view offscreen
        let controller = UIHostingController(rootView: self)
        
        // Size the view to its ideal size (or a fixed size if known)
        let targetSize = controller.view.intrinsicContentSize
        controller.view.frame = CGRect(origin: .zero, size: targetSize)
        
        // Render the view into a bitmap
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let image = renderer.image { context in
            controller.view.layer.render(in: context.cgContext)
        }
        
        return image
    }
}
#endif
