import SwiftUI
import AppKit

struct ContentView: View {
    // MARK: - State
    @State private var topShapeColor: Color = Color(hex: "1E8CCB")
    @State private var bottomShapeColor: Color = Color(hex: "6FCDF6")
    
    @State private var symbolName: String = "star.fill"
    @State private var symbolColor: Color = Color(hex: "1E8CCB")
    @State private var symbolOpacity: Double = 0.5
    
    @State private var topOffset: CGFloat = -141
    @State private var bottomOffset: CGFloat = -81
    
    @State var showIconPicker = false
    
    @State var imageType: ImageType = .sfsymbol
    @State private var dropError: String? = nil
    
    @State var isTargetedDrop = false

    @State var breatheAnimation = false
    @State var rotateAnimation = false
    
    @State var rotationAngle = 0
    
    let timer = Timer.publish(every: 0.75, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geo in
            VSplitView {
                HStack {
                    // MARK: - Live Preview
                    // Show the folder icon at a smaller scale, if desired
                    GeometryReader { smallGeo in
                        VStack {
                            FolderIconView(topShapeColor: $topShapeColor,
                                           bottomShapeColor: $bottomShapeColor,
                                           symbolName: $symbolName,
                                           symbolColor: $symbolColor,
                                           symbolOpacity: $symbolOpacity,
                                           topOffset: $topOffset,
                                           bottomOffset: $bottomOffset,
                                           imageType: $imageType)
                            .frame(width: 200, height: 200)
                            .scaleEffect(0.43)
                            .cornerRadius(10)
                            .zIndex(10)
                            
                            Text("Drag Folders to Set Icons")
                            
                            // -- Save Button
                            Button(action: savePNG) {
                                Text("Save as Image")
                                    .font(.headline)
                                    .padding()
                                    .frame(width: 175)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .buttonStyle(.plain)
                            .padding(.top, 10)
                        }
                        .overlay {
                            ZStack {
                                Color.blue
                                    .frame(width: smallGeo.size.width, height: smallGeo.size.height)
                                
                                VStack {
                                    Text("Drop Folder Here")
                                        .font(.headline)
                                        .foregroundStyle(Color.white)
                                    
                                    Spacer()
                                        .frame(height: 75)
                                    
                                    ZStack {
                                        ZStack {
                                            HStack {
                                                Image(systemName: "chevron.compact.right")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 20)
                                                    .foregroundStyle(Color.white)
                                                
                                                Spacer()
                                                    .frame(width: breatheAnimation ? 190: 120)
                                                    .animation(.bouncy(duration: 0.75), value: breatheAnimation)
                                                
                                                Image(systemName: "chevron.compact.right")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 20)
                                                    .foregroundStyle(Color.white)
                                                    .rotationEffect(Angle(degrees: 180))
                                            }
                                            
                                            HStack {
                                                Image(systemName: "chevron.compact.right")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 20)
                                                    .foregroundStyle(Color.white)
                                                
                                                Spacer()
                                                    .frame(width: breatheAnimation ? 190: 120)
                                                    .animation(.bouncy(duration: 0.75), value: breatheAnimation)
                                                
                                                Image(systemName: "chevron.compact.right")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 20)
                                                    .foregroundStyle(Color.white)
                                                    .rotationEffect(Angle(degrees: 180))
                                                
                                            }.rotationEffect(Angle(degrees: 90))
                                        }.rotationEffect(Angle(degrees: Double(rotationAngle)))
                                            .animation(.bouncy(duration: 0.5), value: rotationAngle)
                                            .onReceive(timer) { thing in
                                                breatheAnimation.toggle()
                                                rotationAngle += 90
                                            }
                                        
                                        FolderIconView(topShapeColor: $topShapeColor,
                                                       bottomShapeColor: $bottomShapeColor,
                                                       symbolName: $symbolName,
                                                       symbolColor: $symbolColor,
                                                       symbolOpacity: $symbolOpacity,
                                                       topOffset: $topOffset,
                                                       bottomOffset: $bottomOffset,
                                                       imageType: $imageType)
                                        .frame(width: 100, height: 100)
                                        .scaleEffect(0.21)
                                    }
                                }
                            }.opacity(isTargetedDrop ? 1 : 0)
                                .animation(.default, value: isTargetedDrop)
                        }
                        .onDrop(of: ["public.file-url"], isTargeted: $isTargetedDrop) { providers in
                            handleDrop(providers: providers)
                        }
                    }

                    Spacer()
                        .frame(width: 20)
                    
                    // MARK: - Controls
                    ScrollView {
                        VStack(alignment: .center, spacing: 20) {
                            // -- Image Type
                            HStack {
                                Text("Type:")
                                    .font(.headline)
                                
                                Spacer()
                            }
                            HStack {
                                Picker("", selection: $imageType) {
                                    ForEach(ImageType.allCases, id: \.self) { value in
                                        Text(value.localizedName)
                                            .tag(value)
                                    }
                                }
                                .pickerStyle(.radioGroup)
                                .horizontalRadioGroupLayout()
                                Spacer()
                            }
                            
                            Divider()
                            
                            // -- Symbol Controls
                            HStack {
                                Text("Symbol:")
                                    .font(.headline)
                                Spacer()
                            }
                            HStack {
                                VStack(alignment: .leading) {
                                    Button {
                                        showIconPicker = true
                                    } label: {
                                        Text(symbolName)
                                            .font(.headline)
                                            .padding(5)
                                            .padding(.horizontal, 10)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    }
                                    .buttonStyle(.plain)
                                    .sheet(isPresented: $showIconPicker) {
                                        VStack {
                                            HStack {
                                                Spacer()
                                                Button {
                                                    showIconPicker = false
                                                } label: {
                                                    Text("Close")
                                                }
                                            }.padding(15)
                                            
                                            IconsPicker(currentIcon: $symbolName)
                                        }
                                    }
                                }
                                .padding(.trailing, 20)
                                
                                VStack(alignment: .leading) {
                                    Text("Opacity: \(Int(symbolOpacity*100))%")
                                    Slider(value: $symbolOpacity, in: 0...1, step: 0.01)
                                        .frame(width: 150)
                                }
                                Spacer()
                            }
                            
                            Divider()
                            
                            // -- Colors
                            HStack {
                                Text("Colors:")
                                    .font(.headline)
                                Spacer()
                            }
                            HStack {
                                VStack(alignment: .center) {
                                    Text("Base")
                                    ColorPicker("", selection: $bottomShapeColor)
                                        .labelsHidden()
                                        .frame(width: 50)
                                }
                                .padding(.trailing, 20)
                                
                                VStack(alignment: .center) {
                                    Text("Tab")
                                    ColorPicker("", selection: $topShapeColor)
                                        .labelsHidden()
                                        .frame(width: 50)
                                }
                                .padding(.trailing, 20)
                                
                                VStack(alignment: .center) {
                                    Text("Symbol")
                                    ColorPicker("", selection: $symbolColor)
                                        .labelsHidden()
                                        .frame(width: 50)
                                }
                                .padding(.trailing, 20)
                            }
                        }
                    }
                    .zIndex(1)
                }
                .padding(20)
                .frame(minHeight: 300, idealHeight: 300)
                
                // MARK: - Presets
                VStack {
                    Text("Preset Colors")
                        .font(.system(.title2, design: .default, weight: .medium))
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .center) {
                            FolderPresetPreview(color1: "1E8CCB", color2: "6FCDF6",
                                                symbolName: $symbolName,
                                                topOffset: $topOffset,
                                                bottomOffset: $bottomOffset,
                                                topShapeColorSetter: $topShapeColor,
                                                bottomShapeColorSetter: $bottomShapeColor,
                                                iconColorSetter: $symbolColor,
                                                opacitySetter: $symbolOpacity)
                            
                            FolderPresetPreview(color1: "D23359", color2: "F66F8F",
                                                symbolName: $symbolName,
                                                topOffset: $topOffset,
                                                bottomOffset: $bottomOffset,
                                                topShapeColorSetter: $topShapeColor,
                                                bottomShapeColorSetter: $bottomShapeColor,
                                                iconColorSetter: $symbolColor,
                                                opacitySetter: $symbolOpacity)
                            
                            FolderPresetPreview(color1: "DA8521", color2: "F6B86F",
                                                symbolName: $symbolName,
                                                topOffset: $topOffset,
                                                bottomOffset: $bottomOffset,
                                                topShapeColorSetter: $topShapeColor,
                                                bottomShapeColorSetter: $bottomShapeColor,
                                                iconColorSetter: $symbolColor,
                                                opacitySetter: $symbolOpacity)
                            
                            FolderPresetPreview(color1: "E1C359", color2: "F6F16F",
                                                symbolName: $symbolName,
                                                topOffset: $topOffset,
                                                bottomOffset: $bottomOffset,
                                                topShapeColorSetter: $topShapeColor,
                                                bottomShapeColorSetter: $bottomShapeColor,
                                                iconColorSetter: $symbolColor,
                                                opacitySetter: $symbolOpacity)
                            
                            FolderPresetPreview(color1: "20731D", color2: "43AC40",
                                                symbolName: $symbolName,
                                                topOffset: $topOffset,
                                                bottomOffset: $bottomOffset,
                                                topShapeColorSetter: $topShapeColor,
                                                bottomShapeColorSetter: $bottomShapeColor,
                                                iconColorSetter: $symbolColor,
                                                opacitySetter: $symbolOpacity)
                            
                            FolderPresetPreview(color1: "2955AB", color2: "5788E5",
                                                symbolName: $symbolName,
                                                topOffset: $topOffset,
                                                bottomOffset: $bottomOffset,
                                                topShapeColorSetter: $topShapeColor,
                                                bottomShapeColorSetter: $bottomShapeColor,
                                                iconColorSetter: $symbolColor,
                                                opacitySetter: $symbolOpacity)
                            
                            FolderPresetPreview(color1: "7125BD", color2: "A750FF",
                                                symbolName: $symbolName,
                                                topOffset: $topOffset,
                                                bottomOffset: $bottomOffset,
                                                topShapeColorSetter: $topShapeColor,
                                                bottomShapeColorSetter: $bottomShapeColor,
                                                iconColorSetter: $symbolColor,
                                                opacitySetter: $symbolOpacity)
                            
                            FolderPresetPreview(color1: "BD2593", color2: "FA62F4",
                                                symbolName: $symbolName,
                                                topOffset: $topOffset,
                                                bottomOffset: $bottomOffset,
                                                topShapeColorSetter: $topShapeColor,
                                                bottomShapeColorSetter: $bottomShapeColor,
                                                iconColorSetter: $symbolColor,
                                                opacitySetter: $symbolOpacity)
                        }
                        .padding(.horizontal, 10)
                    }
                }
                .frame(minHeight: 100, idealHeight: 200)
            }
        }
        .frame(minWidth: 550, minHeight: 500)
    }
    
    // MARK: - Offset Controls
    @ViewBuilder
    private func offsetControls(offset: Binding<CGFloat>) -> some View {
        HStack {
            Button {
                offset.wrappedValue -= 1
            } label: {
                Image(systemName: "minus.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.red)
            }
            
            Slider(value: offset, in: -470...470, step: 1)
                .frame(width: 200)
            
            Button {
                offset.wrappedValue += 1
            } label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.green)
            }
        }
    }
    
    // MARK: - Save as PNG to user-chosen location
    private func savePNG() {
        let panel = NSSavePanel()
        panel.canCreateDirectories = true
        panel.allowedFileTypes = ["png"]
        panel.nameFieldStringValue = "FolderIcon.png"
        
        if panel.runModal() == .OK, let url = panel.url {
            // 1) Render a 470×395 icon at 100% scale
            let fullSizeIcon = FolderIconView(topShapeColor: $topShapeColor,
                                              bottomShapeColor: $bottomShapeColor,
                                              symbolName: $symbolName,
                                              symbolColor: $symbolColor,
                                              symbolOpacity: $symbolOpacity,
                                              topOffset: $topOffset,
                                              bottomOffset: $bottomOffset,
                                              imageType: $imageType)
            
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
    private func handleDrop(providers: [NSItemProvider]) -> Bool {
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
                        try setFolderIcon(folderURL: folderURL)
                        
                    } catch {
                        encounteredError = "Failed to set folder icon: \(error.localizedDescription)"
                    }
                }
            }
        }

        group.notify(queue: .main) {
            dropError = encounteredError
        }

        return true
    }

    // MARK: - Set Folder Icon (Drag-and-Drop) - Unified Logic
    private func setFolderIcon(folderURL: URL) throws {
        // 1) Generate the same 470×395 icon as "Save as Image".
        let fullSizeIcon = FolderIconView(
            topShapeColor: $topShapeColor,
            bottomShapeColor: $bottomShapeColor,
            symbolName: $symbolName,
            symbolColor: $symbolColor,
            symbolOpacity: $symbolOpacity,
            topOffset: $topOffset,
            bottomOffset: $bottomOffset,
            imageType: $imageType
        )
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
    
    // MARK: - Export PNG to a single file in ~/Library/FolderIconChanger
    private func exportIconPNGToLibrary(pngData: Data) throws -> URL {
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
    private func resizeIcon(from sourceURL: URL, maxSize: CGFloat) throws -> NSImage {
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
}
