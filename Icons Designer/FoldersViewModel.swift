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
    
//    @Published var presetLabels: [LocalizedStringKey] = ["light_blue_label", "red_label", "orange_label", "yellow_label", "green_label", "blue_label", "purple_label", "pink_label"]
    @Published var presetLabels: [String: LocalizedStringKey] = ["1E8CCB":"light_blue_label", "D23359": "red_label", "DA8521": "orange_label", "DCAE46": "yellow_label", "20731D": "green_label", "2955AB": "blue_label", "7125BD": "purple_label", "BD2593": "pink_label"]
    
    @Published var dropError: String? = nil
    
    // MARK: - Random Booleans
    @Published var showIconPicker = false
    
    @Published var isTargetedDrop = false

    @Published var breatheAnimation = false
    @Published var rotateAnimation = false
    
    @Published var showSetFolderAlert = false
    
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
//    func preRenderedImage() async -> NSImage? {
//        guard useAdvancedIconRendering,
//              imageType == .png,
//              let image = selectedImage else { return nil }
//
//        return await Task.detached(priority: .userInitiated) {
//            Self.grayscaleMappedImage(from: image, tint: NSColor(self.symbolColor))
//        }.value
//    }


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
    
    static func generateGrayscaleMappedImage(from original: NSImage, tint baseColor: NSColor, completion: @escaping (NSImage?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let result = grayscaleMappedImage(from: original, tint: baseColor)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    private static func clamp<T: Comparable>(_ val: T, _ min: T, _ max: T) -> T {
        Swift.max(min, Swift.min(max, val))
    }
    
    
    func savePNG() {
        let panel = NSSavePanel()
        panel.canCreateDirectories = true
        panel.allowedContentTypes = [.png]
        panel.nameFieldStringValue = "FolderIcon.png"
        
        if panel.runModal() == .OK, let url = panel.url {
            // 1) Render a 470×395 icon at 100% scale. If advanced rendering is
            // enabled we synchronously pre-process the image so the snapshot is
            // fully rendered.
            let fullSizeIcon = FolderIconView(
                resolutionScale: 1.0,
                preRenderedImage: preRenderedImage()
            ).environmentObject(self)
            
            // 2) Use .snapshotAsNSImage (your existing logic)
            let nsImage = fullSizeIcon.snapshotAsNSImage()
            
            // 3) Convert NSImage -> PNG data
            guard let tiffData = nsImage.tiffRepresentation,
                  let bitmap = NSBitmapImageRep(data: tiffData),
                  let pngData = bitmap.representation(using: .png, properties: [:]) else {
                return
            }
            // 4) Write out
            do {
                try pngData.write(to: url)
            } catch {
                print("Failed to save: \(error)")
            }
        }
    }

    // MARK: - Drag-and-Drop Handling
    func handleDrop(providers: [NSItemProvider]) -> Bool {
        let group = DispatchGroup()
        var encounteredError: String? = nil

        for provider in providers {
            group.enter()
            provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { item, error in
                DispatchQueue.main.async {
                    defer { group.leave() }

                    if let error = error {
                        encounteredError = "Error loading item: \(error.localizedDescription)"
                        return
                    }

                    guard let data = item as? Data,
                          let folderURL = URL(dataRepresentation: data, relativeTo: nil) else {
                        encounteredError = "Invalid URL format."
                        return
                    }

                    do {
                        var isDirectory: ObjCBool = false
                        guard FileManager.default.fileExists(atPath: folderURL.path, isDirectory: &isDirectory),
                              isDirectory.boolValue else {
                            encounteredError = "The dropped item is not a folder."
                            return
                        }

                        // Attempt to set the folder icon
                        try self.setFolderIcon(folderURL: folderURL)
                        
                    } catch {
                        encounteredError = "Failed to set folder icon: \(error.localizedDescription)"
                    }
                }
            }
        }

        group.notify(queue: .main) {
//            dropError = encounteredError
        }

        return true
    }

    // MARK: - Set Folder Icon (Drag-and-Drop) - Unified Logic
    func setFolderIcon(folderURL: URL) throws {
        // 1) Generate the same 470×395 icon as "Save as Image".
        let fullSizeIcon = FolderIconView(
            resolutionScale: 1.0,
            preRenderedImage: preRenderedImage()
        ).environmentObject(self)
        let nsImage = fullSizeIcon.snapshotAsNSImage()
        
        // 2) Convert NSImage -> PNG data
        guard let tiffData = nsImage.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let pngData = bitmap.representation(using: .png, properties: [:]) else {
            throw NSError(domain: "FolderIconChanger", code: 1001,
                          userInfo: [NSLocalizedDescriptionKey: "Failed to create PNG data for folder icon."])
        }

        // 3) Write the PNG to a temporary location in ~/Library/FolderIconChanger/currentIcon.png
        let iconURL = try exportIconPNGToLibrary(pngData: pngData)

        // 4) Resize the image for 512x512 (like your example code) and set the folder icon
        let finalIcon = try resizeIcon(from: iconURL, maxSize: 512)
        
        // 5) Apply the icon to the folder
        let workspace = NSWorkspace.shared
        do {
            try workspace.setIcon(finalIcon, forFile: folderURL.path, options: .excludeQuickDrawElementsIconCreationOption)
        } catch {
            throw NSError(domain: "FolderIconChanger", code: 2,
                          userInfo: [NSLocalizedDescriptionKey: "Failed to set folder icon.\n\(error.localizedDescription)"])
        }
    }
    
    func selectFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false          // folders only
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false

        if panel.runModal() == .OK, let url = panel.url {
            do {
                try setFolderIcon(folderURL: url)
                dropError = nil
                showSetFolderAlert = true
            } catch {
                dropError = error.localizedDescription
            }
        }
    }
    
    // MARK: - Export PNG to a single file in ~/Library/FolderIconChanger
    func exportIconPNGToLibrary(pngData: Data) throws -> URL {
        let fileManager = FileManager.default

        // 1) Get Library directory
        guard let libraryDir = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first else {
            throw NSError(domain: "FolderIconChanger", code: 1002,
                          userInfo: [NSLocalizedDescriptionKey: "Unable to locate Library directory."])
        }
        // 2) Create subdirectory if needed
        let appDir = libraryDir.appendingPathComponent("FolderIconChanger")
        if !fileManager.fileExists(atPath: appDir.path) {
            try fileManager.createDirectory(at: appDir, withIntermediateDirectories: true)
        }
        // 3) Write to 'currentIcon.png', overwriting if present
        let iconURL = appDir.appendingPathComponent("currentIcon.png")
        if fileManager.fileExists(atPath: iconURL.path) {
            try fileManager.removeItem(at: iconURL)
        }
        try pngData.write(to: iconURL)
        return iconURL
    }
    
    // MARK: - Resize Icon for Folder (512x512)
    func resizeIcon(from sourceURL: URL, maxSize: CGFloat) throws -> NSImage {
        guard let loadedImage = NSImage(contentsOf: sourceURL) else {
            throw NSError(domain: "FolderIconChanger", code: 1003,
                          userInfo: [NSLocalizedDescriptionKey: "Could not load the PNG from \(sourceURL)."])
        }

        // Scale to fit within maxSize × maxSize
        let targetSize = NSSize(width: maxSize, height: maxSize)
        let result = NSImage(size: targetSize)
        
        result.lockFocus()
        let ratio = min(
            targetSize.width / loadedImage.size.width,
            targetSize.height / loadedImage.size.height
        )
        let newWidth = loadedImage.size.width * ratio
        let newHeight = loadedImage.size.height * ratio
        
        let drawRect = NSRect(
            x: (targetSize.width - newWidth) / 2,
            y: (targetSize.height - newHeight) / 2,
            width: newWidth,
            height: newHeight
        )
        loadedImage.draw(in: drawRect, from: .zero, operation: .sourceOver, fraction: 1.0)
        result.unlockFocus()
        
        return result
    }
    
    func selectImageFile() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.image, .png, .svg]
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        
        if panel.runModal() == .OK, let url = panel.url {
            if let image = NSImage(contentsOf: url) {
                selectedImage = image
            } else {
                print("Failed to load the selected PNG file.")
            }
        }
    }
}
