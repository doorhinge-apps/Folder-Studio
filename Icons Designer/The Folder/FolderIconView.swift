import SwiftUI

enum ImageType: String, Equatable, CaseIterable {
    case none = "None"
    case png = "Image"
//    case svg = "SVG"
    case sfsymbol = "SF Symbol"

    var localizedName: String { rawValue }
}

struct FolderIconView: View {
    @EnvironmentObject var foldersViewModel: FoldersViewModel

    /// Optional pre-processed image. When provided the view will use this image
    /// directly instead of performing asynchronous processing. This allows
    /// export operations to render synchronously.
    var preRenderedImage: NSImage? = nil
//    
//    @Binding var topShapeColor: Color
//    @Binding var bottomShapeColor: Color
//    @Binding var symbolColor: Color
//    @Binding var symbolOpacity: Double
    
    // Final icon dimensions
    private let iconWidth: CGFloat = 470
    private let iconHeight: CGFloat = 395
    
    @State var resolutionScale: Double

    init(resolutionScale: Double, preRenderedImage: NSImage? = nil) {
        _resolutionScale = State(initialValue: resolutionScale)
        self.preRenderedImage = preRenderedImage
    }
    
    @State private var advancedProcessedImage: NSImage? = nil
    
    @State private var imageProcessingTask: Task<Void, Never>? = nil
    @State private var isProcessingImage: Bool = false
    
    var body: some View {
        ZStack {
            FolderHat()
//                .fill(topShapeColor)
                .fill(foldersViewModel.topShapeColor.shadow(.inner(color: .white, radius: 10)))
                .frame(width: iconWidth, height: 114)
                .offset(y: foldersViewModel.topOffset)
            
            ZStack {
                RoundedRectangle(cornerRadius: 35, style: .continuous)
//                    .fill(bottomShapeColor)
                    .fill(foldersViewModel.bottomShapeColor.shadow(.inner(color: .white, radius: 10)))
                    .frame(width: iconWidth, height: 328)
                    .offset(y: 114 + foldersViewModel.bottomOffset)
                
                if foldersViewModel.imageType == .none || foldersViewModel.selectedImage == nil {
                    Spacer()
                        .foregroundStyle(foldersViewModel.symbolColor.shadow(.inner(color: Color(.black).opacity(0.5), radius: 10)))
                        .opacity(foldersViewModel.symbolOpacity)
                        .frame(width: 150, height: 150)
                        .position(x: iconWidth / 2, y: 231)
                        .scaleEffect(foldersViewModel.iconScale)
                        .offset(y: foldersViewModel.iconOffset)
                }
                
                if foldersViewModel.imageType == .sfsymbol {
                    Image(systemName: foldersViewModel.symbolName)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(foldersViewModel.symbolColor.shadow(.inner(color: Color(.black).opacity(0.5), radius: 10)))
                        .fontWeight(
                            foldersViewModel.symbolWeight.rounded() == 1 ? .ultraLight:
                                foldersViewModel.symbolWeight.rounded() == 2 ? .thin:
                                foldersViewModel.symbolWeight.rounded() == 3 ? .light:
                                foldersViewModel.symbolWeight.rounded() == 4 ? .regular:
                                foldersViewModel.symbolWeight.rounded() == 5 ? .medium:
                                foldersViewModel.symbolWeight.rounded() == 6 ? .semibold:
                                foldersViewModel.symbolWeight.rounded() == 7 ? .bold:
                                foldersViewModel.symbolWeight.rounded() == 8 ? .heavy:
                                foldersViewModel.symbolWeight.rounded() == 9 ? .black: .regular
                        )
                        .opacity(foldersViewModel.symbolOpacity)
                        .frame(width: 150, height: 150)
                        .position(x: iconWidth / 2, y: 231)
                        .scaleEffect(foldersViewModel.iconScale)
                        .offset(x: foldersViewModel.iconOffsetX, y: foldersViewModel.iconOffset)
                }
                
                if foldersViewModel.imageType == .png, let image = foldersViewModel.selectedImage {
                    if foldersViewModel.useAdvancedIconRendering {
                        ZStack {
                            if let img = preRenderedImage ?? advancedProcessedImage {
                                Image(nsImage: img)
                                    .resizable()
                                    .scaledToFit()
                                    .opacity(foldersViewModel.symbolOpacity)
                                    .frame(width: 150, height: 150)
                                    .position(x: iconWidth / 2, y: 231)
                                    .scaleEffect(foldersViewModel.iconScale)
                                    .offset(x: foldersViewModel.iconOffsetX, y: foldersViewModel.iconOffset)
                            }

                            if (isProcessingImage || advancedProcessedImage == nil) && preRenderedImage == nil {
                                ProgressView()
                                    .frame(width: 150, height: 150)
                                    .position(x: iconWidth / 2, y: 231)
                            }
                        }
                        .onChange(of: foldersViewModel.symbolColor) { newColor in
                            if preRenderedImage == nil, let image = foldersViewModel.selectedImage {
                                updateAdvancedImageAsync(from: image, tint: NSColor(newColor))
                            }
                        }
                        .onChange(of: foldersViewModel.selectedImage) { newImage in
                            if preRenderedImage == nil, let img = newImage {
                                updateAdvancedImageAsync(from: img, tint: NSColor(foldersViewModel.symbolColor))
                            }
                        }
                        .onAppear {
                            if preRenderedImage == nil,
                               foldersViewModel.useAdvancedIconRendering,
                               let img = foldersViewModel.selectedImage {
                                updateAdvancedImageAsync(from: img, tint: NSColor(foldersViewModel.symbolColor))
                            }
                        }
                    }
                    else {
                        ZStack {
                            ZStack {
                                Image(nsImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.shadow(.inner(color: Color(.black).opacity(0.5), radius: 10)))
                                    .opacity(foldersViewModel.symbolOpacity)
                                    .frame(width: 150, height: 150)
                                    .position(x: iconWidth / 2, y: 231)
                                    .scaleEffect(foldersViewModel.iconScale)
                                    .offset(x: foldersViewModel.iconOffsetX, y: foldersViewModel.iconOffset)
                                
                                foldersViewModel.symbolColor.blendMode(.sourceAtop)
                            }.drawingGroup(opaque: false)
                        }
                    }
                }

            }
        }
        .overlay(content: {
            Image("Grainy Grain")
                .ignoresSafeArea()
                .opacity(0.15)
                .frame(width: iconWidth, height: iconHeight)
                .clipShape(FolderClippingShape())
        })
//        .clipped()
        .clipShape(FolderClippingShape())
        .frame(width: iconWidth, height: iconHeight)
    }
    
    private func grayscaleMappedImage(from original: NSImage, tint baseColor: NSColor) -> NSImage? {
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

        // Color midpoint (base color)
        let baseR = baseColor.redComponent
        let baseG = baseColor.greenComponent
        let baseB = baseColor.blueComponent

        let deviation: CGFloat = 0.25 // ±0.25 around midpoint (0.5 → [0.25, 0.75])

        let minC: CGFloat   = 0.10      // darkest allowed component
        let maxC: CGFloat   = 0.90      // lightest allowed component
        let whiteCutoff     = 0.90      // >90 % gray ⇒ transparent

        for i in 0..<(width * height) {
            let o = i * 4

            // ---- Preserve existing transparency ----
            let originalAlpha = ptr[o + 3]
            if originalAlpha == 0 { continue }            // already transparent
            // ----------------------------------------

            let r = Double(ptr[o])
            let g = Double(ptr[o + 1])
            let b = Double(ptr[o + 2])

            let gray = (0.299*r + 0.587*g + 0.114*b) / 255.0   // 0…1

            // ---- Turn near‑white into transparency ----
            if gray > whiteCutoff {
                ptr[o + 3] = 0                 // fully transparent
                continue                        // skip colouring
            }
            // -------------------------------------------

            // tone‑mapping around midpoint
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
            ptr[o + 3] = originalAlpha          // keep original opacity
        }


        guard let outputCG = context.makeImage() else { return nil }
        return NSImage(cgImage: outputCG, size: NSSize(width: width, height: height))
    }

    private func clamp<T: Comparable>(_ val: T, _ min: T, _ max: T) -> T {
        Swift.max(min, Swift.min(max, val))
    }

    private func updateAdvancedImageAsync(from original: NSImage, tint: NSColor) {
        imageProcessingTask?.cancel()
        isProcessingImage = true

        imageProcessingTask = Task(priority: .userInitiated) {
            let result = await withTaskCancellationHandler {
                return grayscaleMappedImage(from: original, tint: tint)
            } onCancel: {
                // Optional: Clean up if needed
            }

            await MainActor.run {
                if !Task.isCancelled {
                    self.advancedProcessedImage = result
                    self.isProcessingImage = false
                }
            }
        }
    }
}


struct PresetFolderIconView: View {
    @EnvironmentObject var foldersViewModel: FoldersViewModel

    /// Pre-rendered image used when exporting preset previews.
    var preRenderedImage: NSImage? = nil
    
    @Binding var topShapeColor: Color
    @Binding var bottomShapeColor: Color
    @Binding var symbolColor: Color
    @Binding var symbolOpacity: Double
    
    // Final icon dimensions
    private let iconWidth: CGFloat = 470
    private let iconHeight: CGFloat = 395
    
    @State var resolutionScale: Double

    init(resolutionScale: Double, preRenderedImage: NSImage? = nil,
         topShapeColor: Binding<Color>, bottomShapeColor: Binding<Color>,
         symbolColor: Binding<Color>, symbolOpacity: Binding<Double>) {
        _resolutionScale = State(initialValue: resolutionScale)
        self.preRenderedImage = preRenderedImage
        self._topShapeColor = topShapeColor
        self._bottomShapeColor = bottomShapeColor
        self._symbolColor = symbolColor
        self._symbolOpacity = symbolOpacity
    }
    
    @State private var advancedProcessedImage: NSImage? = nil
    
    @State private var imageProcessingTask: Task<Void, Never>? = nil
    @State private var isProcessingImage: Bool = false
    
    var body: some View {
        ZStack {
            FolderHat()
//                .fill(topShapeColor)
                .fill(topShapeColor.shadow(.inner(color: .white, radius: 10)))
                .frame(width: iconWidth, height: 114)
                .offset(y: foldersViewModel.topOffset)
            
            ZStack {
                RoundedRectangle(cornerRadius: 35, style: .continuous)
//                    .fill(bottomShapeColor)
                    .fill(bottomShapeColor.shadow(.inner(color: .white, radius: 10)))
                    .frame(width: iconWidth, height: 328)
                    .offset(y: 114 + foldersViewModel.bottomOffset)
                
                if foldersViewModel.imageType == .none || foldersViewModel.selectedImage == nil {
                    Spacer()
                        .foregroundStyle(symbolColor.shadow(.inner(color: Color(.black).opacity(0.5), radius: 10)))
                        .opacity(symbolOpacity)
                        .frame(width: 150, height: 150)
                        .position(x: iconWidth / 2, y: 231)
                        .scaleEffect(foldersViewModel.iconScale)
                        .offset(y: foldersViewModel.iconOffset)
                }
                
                if foldersViewModel.imageType == .sfsymbol {
                    Image(systemName: foldersViewModel.symbolName)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(symbolColor.shadow(.inner(color: Color(.black).opacity(0.5), radius: 10)))
                        .fontWeight(
                            foldersViewModel.symbolWeight.rounded() == 1 ? .ultraLight:
                                foldersViewModel.symbolWeight.rounded() == 2 ? .thin:
                                foldersViewModel.symbolWeight.rounded() == 3 ? .light:
                                foldersViewModel.symbolWeight.rounded() == 4 ? .regular:
                                foldersViewModel.symbolWeight.rounded() == 5 ? .medium:
                                foldersViewModel.symbolWeight.rounded() == 6 ? .semibold:
                                foldersViewModel.symbolWeight.rounded() == 7 ? .bold:
                                foldersViewModel.symbolWeight.rounded() == 8 ? .heavy:
                                foldersViewModel.symbolWeight.rounded() == 9 ? .black: .regular
                        )
                        .opacity(symbolOpacity)
                        .frame(width: 150, height: 150)
                        .position(x: iconWidth / 2, y: 231)
                        .scaleEffect(foldersViewModel.iconScale)
                        .offset(x: foldersViewModel.iconOffsetX, y: foldersViewModel.iconOffset)
                }
                
                if foldersViewModel.imageType == .png, let image = foldersViewModel.selectedImage {
                    if foldersViewModel.useAdvancedIconRendering {
                        ZStack {
                            if let img = preRenderedImage ?? advancedProcessedImage {
                                Image(nsImage: img)
                                    .resizable()
                                    .scaledToFit()
                                    .opacity(symbolOpacity)
                                    .frame(width: 150, height: 150)
                                    .position(x: iconWidth / 2, y: 231)
                                    .scaleEffect(foldersViewModel.iconScale)
                                    .offset(x: foldersViewModel.iconOffsetX, y: foldersViewModel.iconOffset)
                            }

                            if (isProcessingImage || advancedProcessedImage == nil) && preRenderedImage == nil {
                                ProgressView()
                                    .frame(width: 150, height: 150)
                                    .position(x: iconWidth / 2, y: 231)
                            }
                        }
                        .onChange(of: symbolColor) { newColor in
                            if preRenderedImage == nil, let image = foldersViewModel.selectedImage {
                                updateAdvancedImageAsync(from: image, tint: NSColor(newColor))
                            }
                        }
                        .onChange(of: foldersViewModel.selectedImage) { newImage in
                            if preRenderedImage == nil, let img = newImage {
                                updateAdvancedImageAsync(from: img, tint: NSColor(symbolColor))
                            }
                        }
                        .onAppear {
                            if preRenderedImage == nil,
                               foldersViewModel.useAdvancedIconRendering,
                               let img = foldersViewModel.selectedImage {
                                updateAdvancedImageAsync(from: img, tint: NSColor(symbolColor))
                            }
                        }
                    }
                    else {
                        ZStack {
                            ZStack {
                                Image(nsImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.shadow(.inner(color: Color(.black).opacity(0.5), radius: 10)))
                                    .opacity(symbolOpacity)
                                    .frame(width: 150, height: 150)
                                    .position(x: iconWidth / 2, y: 231)
                                    .scaleEffect(foldersViewModel.iconScale)
                                    .offset(x: foldersViewModel.iconOffsetX, y: foldersViewModel.iconOffset)
                                
                                symbolColor.blendMode(.sourceAtop)
                            }.drawingGroup(opaque: false)
                        }
                    }
                }

            }
        }
        .overlay(content: {
            Image("Grainy Grain")
                .ignoresSafeArea()
                .opacity(0.15)
                .frame(width: iconWidth, height: iconHeight)
                .clipShape(FolderClippingShape())
        })
//        .clipped()
        .clipShape(FolderClippingShape())
        .frame(width: iconWidth, height: iconHeight)
    }
    
    private func grayscaleMappedImage(from original: NSImage, tint baseColor: NSColor) -> NSImage? {
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

        // Color midpoint (base color)
        let baseR = baseColor.redComponent
        let baseG = baseColor.greenComponent
        let baseB = baseColor.blueComponent

        let deviation: CGFloat = 0.25 // ±0.25 around midpoint (0.5 → [0.25, 0.75])

        let minC: CGFloat   = 0.10      // darkest allowed component
        let maxC: CGFloat   = 0.90      // lightest allowed component
        let whiteCutoff     = 0.90      // >90 % gray ⇒ transparent

        for i in 0..<(width * height) {
            let o = i * 4

            // ---- Preserve existing transparency ----
            let originalAlpha = ptr[o + 3]
            if originalAlpha == 0 { continue }            // already transparent
            // ----------------------------------------

            let r = Double(ptr[o])
            let g = Double(ptr[o + 1])
            let b = Double(ptr[o + 2])

            let gray = (0.299*r + 0.587*g + 0.114*b) / 255.0   // 0…1

            // ---- Turn near‑white into transparency ----
            if gray > whiteCutoff {
                ptr[o + 3] = 0                 // fully transparent
                continue                        // skip colouring
            }
            // -------------------------------------------

            // tone‑mapping around midpoint
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
            ptr[o + 3] = originalAlpha          // keep original opacity
        }


        guard let outputCG = context.makeImage() else { return nil }
        return NSImage(cgImage: outputCG, size: NSSize(width: width, height: height))
    }

    private func clamp<T: Comparable>(_ val: T, _ min: T, _ max: T) -> T {
        Swift.max(min, Swift.min(max, val))
    }

    private func updateAdvancedImageAsync(from original: NSImage, tint: NSColor) {
        imageProcessingTask?.cancel()
        isProcessingImage = true

        imageProcessingTask = Task(priority: .userInitiated) {
            let result = await withTaskCancellationHandler {
                return grayscaleMappedImage(from: original, tint: tint)
            } onCancel: {
                // Optional: Clean up if needed
            }

            await MainActor.run {
                if !Task.isCancelled {
                    self.advancedProcessedImage = result
                    self.isProcessingImage = false
                }
            }
        }
    }
}
