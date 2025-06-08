import SwiftUI
import AppKit
import Translation

struct ContentView: View {
    @EnvironmentObject var foldersViewModel: FoldersViewModel
    
    let timer = Timer.publish(every: 0.75, on: .main, in: .common).autoconnect()
    
    @State var showSetFolderAlert = false
    
    @State private var pos: [CGFloat] = [0, 0]
    
    var body: some View {
        GeometryReader { geo in
            VSplitView {
                HStack(spacing: 0) {
                    Button {
                        //
                    } label: {
                        Presets()
                    }.buttonStyle(.plain)
                    
                    PreviewDrag()
                        .accessibilityLabel("accessibility_folder_preview_label")

                    Spacer()
                        .frame(width: 20)
                    
                    GeometryReader { rightGeo in
                        // MARK: - Controls
                            VStack(alignment: .center, spacing: 20) {
                                // -- Image Type
                                HStack {
                                    Text("type_selector_label")
                                        .font(.system(.title, design: .rounded, weight: .bold))
                                        .foregroundStyle(Color.white)
                                        .accessibilityHidden(true)
                                    
                                    Spacer()
                                }
                                HStack {
                                    GeometryReader { pickerGeo in
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color(hex: "4C7C97"))
                                                .stroke(Color(hex: "4C7C97"), lineWidth: 3)
                                                .frame(height: 30)
                                                .offset(y: 5)
                                            
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color(hex: "78D6FF"))
                                                .stroke(Color(hex: "1E8CCB"), lineWidth: 3)
                                                .frame(height: 30)
                                            
                                            HStack(alignment: .center) {
                                                if foldersViewModel.imageType != .none {
                                                    Spacer()
                                                }
                                                
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color(hex: "4C7C97"))
                                                    .stroke(Color(hex: "4C7C97"), lineWidth: 3)
                                                    .frame(width: pickerGeo.size.width/3)
                                                    .overlay {
                                                        ZStack {
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .stroke(Color.black.opacity(0.5), lineWidth: 6)
                                                                .blur(radius: 4)
                                                                .mask(
                                                                    RoundedRectangle(cornerRadius: 10)
                                                                )
                                                            
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .fill(Color(hex: "4C7C97").opacity(0.0))
                                                                .stroke(Color(hex: "4C7C97"), lineWidth: 3)
                                                        }
                                                    }
                                                
                                                if foldersViewModel.imageType != .sfsymbol {
                                                    Spacer()
                                                }
                                            }.frame(width: pickerGeo.size.width)
                                                .animation(.default)
                                            
                                            HStack(spacing: 0) {
                                                Text("type_none_label")
                                                    .frame(width: pickerGeo.size.width/3)
                                                    .accessibilityHidden(true)
                                                
                                                Text("type_image_label")
                                                    .frame(width: pickerGeo.size.width/3)
                                                    .accessibilityHidden(true)
                                                
                                                Text("type_sfsymbol_label")
                                                    .frame(width: pickerGeo.size.width/3)
                                                    .accessibilityHidden(true)
                                            }.foregroundStyle(Color.white)
                                            
                                            HStack(spacing: 0) {
                                                // None
                                                Button { foldersViewModel.imageType = .none } label: {
                                                    Color.clear
                                                        .frame(width: pickerGeo.size.width/3, height: 30)
                                                }
                                                .buttonStyle(.plain)

                                                // Image
                                                Button { foldersViewModel.imageType = .png } label: {
                                                    Color.clear
                                                        .frame(width: pickerGeo.size.width/3, height: 30)
                                                }
                                                .buttonStyle(.plain)

                                                // SF Symbol
                                                Button { foldersViewModel.imageType = .sfsymbol } label: {
                                                    Color.clear
                                                        .frame(width: pickerGeo.size.width/3, height: 30)
                                                }
                                                .buttonStyle(.plain)
                                            }
                                            .accessibilityElement(children: .ignore)
                                            .accessibilityLabel(
                                                Text("accessibility_type_selector_label")
                                                + Text(", ")
                                                + Text(
                                                    foldersViewModel.imageType == .none
                                                        ? "type_none_label"
                                                    : foldersViewModel.imageType == .png
                                                        ? "type_image_label"
                                                        : "type_sfsymbol_label"
                                                )
                                            )
                                            .accessibilityAction(named: Text("type_none_label")) {
                                                foldersViewModel.imageType = .none
                                            }
                                            .accessibilityAction(named: Text("type_image_label")) {
                                                foldersViewModel.imageType = .png
                                            }
                                            .accessibilityAction(named: Text("type_sfsymbol_label")) {
                                                foldersViewModel.imageType = .sfsymbol
                                            }

                                            
                                        }
                                    }
                                }.padding(5)
                                .frame(height: 30)
                                
//                                Divider()
                                
                                if foldersViewModel.imageType != .none {
                                    // -- Symbol Controls
                                    HStack(alignment: .top) {
                                        
                                        VStack(alignment: .leading) {
                                            Spacer()
                                                .frame(height: 80)
                                            
                                            if foldersViewModel.imageType == .png {
                                                if let image = foldersViewModel.selectedImage {
                                                    Image(nsImage: image)
                                                        .resizable()
                                                        .scaledToFit()
                                                        //.frame(width: 100, height: 100)
                                                }
                                                
                                                Button {
                                                    foldersViewModel.selectImageFile()
                                                } label: {
                                                    Text(foldersViewModel.selectedImage != nil ? "change_image": "select_image")
                                                }
                                                .buttonStyle(SmallButton3DStyle())
                                                .frame(width: 100, height: 30)
                                                .accessibilityLabel("accessibility_select_or_change_image_label")
                                            }
                                            else if foldersViewModel.imageType == .sfsymbol {
                                                VStack(alignment: .center) {
                                                    Image(systemName: foldersViewModel.symbolName)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .foregroundStyle(Color(hex: "78D6FF"))
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
                                                        .frame(width: 100, height: 100)
                                                        .fontWeight(.black)
                                                        .modifier(ShadowStrokeModifier())
                                                        .onTapGesture {
                                                            foldersViewModel.showIconPicker = true
                                                        }
                                                        
                                                    
                                                    //HStack(alignment: .center) {
                                                    Button {
                                                        foldersViewModel.showIconPicker = true
                                                    } label: {
                                                        Text(foldersViewModel.symbolName)
                                                    }
                                                    .buttonStyle(SmallButton3DStyle())
                                                    .frame(width: 100, height: 30)
                                                    .padding()
                                                    .popover(isPresented: $foldersViewModel.showIconPicker) {
                                                        VStack {
                                                            HStack {
                                                                Spacer()
                                                                Button {
                                                                    foldersViewModel.showIconPicker = false
                                                                } label: {
                                                                    Text("close_popup")
                                                                }
                                                            }.padding(15)
                                                            
                                                            IconsPicker(currentIcon: $foldersViewModel.symbolName)
                                                        }
                                                    }
                                                    //}
                                                }
                                            }
                                        }
                                        .padding(.trailing, 20)
                                        .frame(minWidth: 200)
                                        
                                        ScrollView(showsIndicators: false) {
                                            VStack(alignment: .leading) {
                                                if foldersViewModel.imageType == .png {
                                                    HStack {
                                                        GeometryReader { advancedImagePicker in
                                                            ZStack {
                                                                RoundedRectangle(cornerRadius: 10)
                                                                    .fill(Color(hex: "4C7C97"))
                                                                    .stroke(Color(hex: "4C7C97"), lineWidth: 3)
                                                                    .frame(height: 30)
                                                                    .offset(y: 5)
                                                                
                                                                RoundedRectangle(cornerRadius: 10)
                                                                    .fill(Color(hex: "78D6FF"))
                                                                    .stroke(Color(hex: "1E8CCB"), lineWidth: 3)
                                                                    .frame(height: 30)
                                                                
                                                                HStack {
                                                                    if foldersViewModel.useAdvancedIconRendering {
                                                                        Spacer()
                                                                    }
                                                                    
                                                                    RoundedRectangle(cornerRadius: 10)
                                                                        .fill(Color(hex: "4C7C97"))
                                                                        .stroke(Color(hex: "4C7C97"), lineWidth: 3)
                                                                        .frame(width: advancedImagePicker.size.width/2)
                                                                        .overlay {
                                                                            ZStack {
                                                                                RoundedRectangle(cornerRadius: 10)
                                                                                    .stroke(Color.black.opacity(0.5), lineWidth: 6)
                                                                                    .blur(radius: 4)
                                                                                    .mask(
                                                                                        RoundedRectangle(cornerRadius: 10)
                                                                                    )
                                                                                
                                                                                RoundedRectangle(cornerRadius: 10)
                                                                                    .fill(Color(hex: "4C7C97").opacity(0.0))
                                                                                    .stroke(Color(hex: "4C7C97"), lineWidth: 3)
                                                                            }
                                                                        }
                                                                    
                                                                    if !foldersViewModel.useAdvancedIconRendering {
                                                                        Spacer()
                                                                    }
                                                                }.frame(width: advancedImagePicker.size.width)
                                                                    .animation(.default)
                                                                
                                                                HStack(spacing: 0) {
                                                                    Text("standard_image_mode")
                                                                        .frame(width: advancedImagePicker.size.width/2)
                                                                        .accessibilityHidden(true)
                                                                    
                                                                    Text("advanced_image_mode")
                                                                        .frame(width: advancedImagePicker.size.width/2)
                                                                        .accessibilityHidden(true)
                                                                }.foregroundStyle(Color.white)
                                                                
                                                                HStack(spacing: 0) {
                                                                    Button {
                                                                        foldersViewModel.useAdvancedIconRendering = false
                                                                    } label: {
                                                                        Color.clear
                                                                            .frame(width: advancedImagePicker.size.width/2, height: 30)
                                                                    }
                                                                    .buttonStyle(.plain)
                                                                    .accessibilityLabel(Text("standard_image_mode"))
                                                                    .accessibilityAddTraits(
                                                                        foldersViewModel.useAdvancedIconRendering ? [] : .isSelected
                                                                    )

                                                                    Button {
                                                                        foldersViewModel.useAdvancedIconRendering = true
                                                                    } label: {
                                                                        Color.clear
                                                                            .frame(width: advancedImagePicker.size.width/2, height: 30)
                                                                    }
                                                                    .buttonStyle(.plain)
                                                                    .accessibilityLabel(Text("advanced_image_mode"))
                                                                    .accessibilityAddTraits(
                                                                        foldersViewModel.useAdvancedIconRendering ? .isSelected : []
                                                                    )
                                                                }
                                                                .accessibilityElement(children: .combine)
                                                                    .accessibilityLabel("accessibility_image_rendering_selector_label")
                                                                
                                                            }
                                                            
                                                        }
                                                    }.padding([.leading, .vertical], 5)
                                                        .padding(.trailing)
                                                        .frame(height: 30)
                                                }
                                                
                                                if foldersViewModel.imageType == .sfsymbol {
                                                    HStack {
                                                        Text("font_weight_label")
                                                            .foregroundStyle(Color.white)
                                                            .font(.system(.title3, design: .rounded, weight: .semibold))
                                                        
                                                        Spacer()
                                                        
                                                        Button {
                                                            withAnimation {
                                                                foldersViewModel.symbolWeight = 4.0
                                                            }
                                                        } label: {
                                                            Text("reset_label")
                                                                .padding(.horizontal, 20)
                                                        }
                                                        .buttonStyle(SmallButton3DStyle())
                                                        .frame(height: 30)
                                                        .fixedSize()
                                                        .padding([.top, .bottom])
                                                        
                                                        Button {
                                                            withAnimation {
                                                                foldersViewModel.hideWeight.toggle()
                                                            }
                                                        } label: {
                                                            Image(systemName: "chevron.down")
                                                                .rotationEffect(Angle(degrees: !foldersViewModel.hideWeight ? -180: 0))
                                                                .accessibilityLabel(foldersViewModel.hideWeight ? "accessibility_expand_label": "accessibility_collapse_label")
                                                        }
                                                        .buttonStyle(SmallButton3DStyle())
                                                        .frame(width: 30, height: 30)
                                                        .padding([.top, .bottom, .trailing])
                                                    }
                                                    
                                                    if !foldersViewModel.hideWeight {
                                                        CustomSlider(value: $foldersViewModel.symbolWeight, minValue: 1, maxValue: 9)
                                                            .padding(.horizontal, 5)
                                                    }
                                                    
                                                    Divider()
                                                }
                                                
                                                HStack {
                                                    //                                                Text("Opacity: \(Int(symbolOpacity*100))%")
                                                    Text("opacity_label")
                                                        .foregroundStyle(Color.white)
                                                        .font(.system(.title3, design: .rounded, weight: .semibold))
                                                    
                                                    Spacer()
                                                    
                                                    Button {
                                                        withAnimation {
                                                            foldersViewModel.symbolOpacity = 0.5
                                                        }
                                                    } label: {
                                                        Text("reset_label")
                                                            .padding(.horizontal, 20)
                                                    }
                                                    .buttonStyle(SmallButton3DStyle())
                                                    .frame(height: 30)
                                                    .fixedSize()
                                                    .padding([.top, .bottom])
                                                    
                                                    Button {
                                                        withAnimation {
                                                            foldersViewModel.hideOpacity.toggle()
                                                        }
                                                    } label: {
                                                        Image(systemName: "chevron.down")
                                                            .rotationEffect(Angle(degrees: !foldersViewModel.hideOpacity ? -180: 0))
                                                            .accessibilityLabel(foldersViewModel.hideOpacity ? "accessibility_expand_label": "accessibility_collapse_label")
                                                    }
                                                    .buttonStyle(SmallButton3DStyle())
                                                    .frame(width: 30, height: 30)
                                                    .padding([.top, .bottom, .trailing])
                                                }
                                                
                                                if !foldersViewModel.hideOpacity {
                                                    CustomSlider(value: $foldersViewModel.symbolOpacity, minValue: 0, maxValue: 1)
                                                        //.frame(width: 200)
                                                        .padding(.horizontal, 5)
                                                }
                                                
                                                Divider()
                                                
                                                HStack {
                                                    //                                                Text("Scale: \(Int(iconScale*100))%")
                                                    Text("scale_label")
                                                        .foregroundStyle(Color.white)
                                                        .font(.system(.title3, design: .rounded, weight: .semibold))
                                                    
                                                    Spacer()
                                                    
                                                    Button {
                                                        withAnimation {
                                                            foldersViewModel.iconScale = 1.0
                                                        }
                                                    } label: {
                                                        Text("reset_label")
                                                            .padding(.horizontal, 20)
                                                    }
                                                    .buttonStyle(SmallButton3DStyle())
                                                    .frame(height: 30)
                                                    .fixedSize()
                                                    .padding([.top, .bottom])
                                                    
                                                    Button {
                                                        withAnimation {
                                                            foldersViewModel.hideScale.toggle()
                                                        }
                                                    } label: {
                                                        Image(systemName: "chevron.down")
                                                            .rotationEffect(Angle(degrees: !foldersViewModel.hideScale ? -180: 0))
                                                            .accessibilityLabel(foldersViewModel.hideScale ? "accessibility_expand_label": "accessibility_collapse_label")
                                                    }
                                                    .buttonStyle(SmallButton3DStyle())
                                                    .frame(width: 30, height: 30)
                                                    .padding([.top, .bottom, .trailing])
                                                }
                                                
                                                if !foldersViewModel.hideScale {
                                                    CustomSlider(value: $foldersViewModel.iconScale, minValue: 0.2, maxValue: 5)
                                                        //.frame(width: 200)
                                                        .padding(.horizontal, 5)
                                                }
                                                
                                                Divider()
                                                
                                                HStack {
                                                    Text("offset_label")
                                                        .foregroundStyle(Color.white)
                                                        .font(.system(.title3, design: .rounded, weight: .semibold))
                                                    
                                                    Spacer()
                                                    
                                                    Button {
                                                        withAnimation {
                                                            foldersViewModel.iconOffset = 0
                                                            foldersViewModel.iconOffsetX = 0
                                                        }
                                                    } label: {
                                                        Text("reset_label")
                                                            .padding(.horizontal, 20)
                                                    }
                                                    .buttonStyle(SmallButton3DStyle())
                                                    .frame(height: 30)
                                                    .fixedSize()
                                                    .padding([.top, .bottom])
                                                    
                                                    Button {
                                                        withAnimation {
                                                            foldersViewModel.hideOffset.toggle()
                                                        }
                                                    } label: {
                                                        Image(systemName: "chevron.down")
                                                            .rotationEffect(Angle(degrees: !foldersViewModel.hideOffset ? -180: 0))
                                                            .accessibilityLabel(foldersViewModel.hideOffset ? "accessibility_expand_label": "accessibility_collapse_label")
                                                    }
                                                    .buttonStyle(SmallButton3DStyle())
                                                    .frame(width: 30, height: 30)
                                                    .padding([.top, .bottom, .trailing])
                                                }
                                                .onChange(of: pos) { oldValue, newValue in
                                                    foldersViewModel.iconOffset = newValue[1]
                                                    foldersViewModel.iconOffsetX = newValue[0]
                                                }
                                                .onChange(of: foldersViewModel.iconOffset * foldersViewModel.iconOffsetX + foldersViewModel.iconOffset + foldersViewModel.iconOffsetX) { oldValue, newValue in
                                                    withAnimation {
                                                        pos = [foldersViewModel.iconOffsetX, foldersViewModel.iconOffset]
                                                    }
                                                }
                                                
                                                if !foldersViewModel.hideOffset {
                                                    AxisPicker(
                                                        coords: $pos,
                                                        xMin: -200,  xMax: 200,
                                                        yMin: -200,  yMax: 200
                                                    )
                                                    .padding(.horizontal, 5)
                                                    .padding(.bottom, 20)
                                                }
                                            }
                                        }
                                        .accessibilityLabel("accessibility_options_panel_label")
                                        Spacer()
                                    }
                                    
                                }
                            }
                            .frame(width: rightGeo.size.width)
                        .zIndex(1)
                    }
                }
                .padding([.horizontal, .top], 20)
                .frame(minHeight: 300, idealHeight: 500)
            }
        }
        .frame(minWidth: 950, minHeight: 500)
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
    
//    private func selectImageFile() {
//        let panel = NSOpenPanel()
//        panel.allowedContentTypes = [.image, .png, .svg]
//        panel.canChooseFiles = true
//        panel.canChooseDirectories = false
//        
//        if panel.runModal() == .OK, let url = panel.url {
//            if let image = NSImage(contentsOf: url) {
//                foldersViewModel.selectedImage = image
//            } else {
//                print("Failed to load the selected PNG file.")
//            }
//        }
//    }
    
    
    // MARK: - Save as PNG to user-chosen location
    /*private func savePNG() {
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
                preRenderedImage: foldersViewModel.preRenderedImage()
            ).environmentObject(foldersViewModel)
            
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
            foldersViewModel.dropError = encounteredError
        }

        return true
    }

    // MARK: - Set Folder Icon (Drag-and-Drop) - Unified Logic
    private func setFolderIcon(folderURL: URL) throws {
        // 1) Generate the same 470×395 icon as "Save as Image".
        let fullSizeIcon = FolderIconView(
            resolutionScale: 1.0,
            preRenderedImage: foldersViewModel.preRenderedImage()
        ).environmentObject(foldersViewModel)
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
    
    private func selectFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false          // folders only
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false

        if panel.runModal() == .OK, let url = panel.url {
            do {
                try setFolderIcon(folderURL: url)
                foldersViewModel.dropError = nil
                showSetFolderAlert = true
            } catch {
                foldersViewModel.dropError = error.localizedDescription
            }
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
    }*/

    // MARK: - Resize Icon for Folder (512x512)
//    private func resizeIcon(from sourceURL: URL, maxSize: CGFloat) throws -> NSImage {
//        guard let loadedImage = NSImage(contentsOf: sourceURL) else {
//            throw NSError(domain: "FolderIconChanger", code: 1003,
//                          userInfo: [NSLocalizedDescriptionKey: "Could not load the PNG from \(sourceURL)."])
//        }
//
//        // Scale to fit within maxSize × maxSize
//        let targetSize = NSSize(width: maxSize, height: maxSize)
//        let result = NSImage(size: targetSize)
//        
//        result.lockFocus()
//        let ratio = min(
//            targetSize.width / loadedImage.size.width,
//            targetSize.height / loadedImage.size.height
//        )
//        let newWidth = loadedImage.size.width * ratio
//        let newHeight = loadedImage.size.height * ratio
//        
//        let drawRect = NSRect(
//            x: (targetSize.width - newWidth) / 2,
//            y: (targetSize.height - newHeight) / 2,
//            width: newWidth,
//            height: newHeight
//        )
//        loadedImage.draw(in: drawRect, from: .zero, operation: .sourceOver, fraction: 1.0)
//        result.unlockFocus()
//        
//        return result
//    }
}
