import SwiftUI
import AppKit

struct ContentView: View {
    @EnvironmentObject var foldersViewModel: FoldersViewModel
    
    let timer = Timer.publish(every: 0.75, on: .main, in: .common).autoconnect()
    
    @State var bottomShapeColor = Color.blue
    @State var topShapeColor = Color.blue
    @State var symbolColor = Color.blue
    
    @State var bottomShapeColorIsUpdating: Bool = false
    @State var topShapeColorIsUpdating: Bool = false
    @State var symbolColorIsUpdating: Bool = false
    
    @State private var pos: [CGFloat] = [0, 0]
    
    var body: some View {
        GeometryReader { geo in
            VSplitView {
                HStack(spacing: 0) {
                    HStack {
                        Text("Presets")
                            .font(.system(.title, design: .rounded, weight: .bold))
                            .rotationEffect(Angle(degrees: -90))
                            .foregroundStyle(Color.white)
                            .frame(width: 200, height: 20)
                    }.frame(width: 10)
                        .offset(x: -10)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading) {
                            ForEach(foldersViewModel.presets, id:\.self) { preset in
                                FolderPresetPreview(
                                    color1: preset[0],
                                    color2: preset[1]
                                )
                            }
                        }
                    }.frame(width: 80)
                        .offset(x: -5)
                    
                    GeometryReader { smallGeo in
                        VStack {
                            VStack {
                                FolderIconView(
                                    resolutionScale: 0.25
                                )
                                .frame(width: 200, height: 200)
                                .scaleEffect(0.43)
                                .cornerRadius(10)
                                .zIndex(10)
                                
                                Text("Drag Folders to Set Icons")
                                
                                Button(action: savePNG) {
                                    Text("Save as Image")
                                }
                                .buttonStyle(Button3DStyle())
                                .frame(width: 200, height: 50)
                                .padding(.top, 10)
                            }
                            .overlay {
                                ZStack {
                                    Color(hex: "78D6FF")
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
                                                        .frame(width: foldersViewModel.breatheAnimation ? 190: 120)
                                                        .animation(.bouncy(duration: 0.75), value: foldersViewModel.breatheAnimation)
                                                    
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
                                                        .frame(width: foldersViewModel.breatheAnimation ? 190: 120)
                                                        .animation(.bouncy(duration: 0.75), value: foldersViewModel.breatheAnimation)
                                                    
                                                    Image(systemName: "chevron.compact.right")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 20)
                                                        .foregroundStyle(Color.white)
                                                        .rotationEffect(Angle(degrees: 180))
                                                    
                                                }.rotationEffect(Angle(degrees: 90))
                                            }.rotationEffect(Angle(degrees: Double(foldersViewModel.rotationAngle)))
                                                .animation(.bouncy(duration: 0.5), value: foldersViewModel.rotationAngle)
                                                .onReceive(timer) { thing in
                                                    foldersViewModel.breatheAnimation.toggle()
                                                    foldersViewModel.rotationAngle += 90
                                                }
                                            
                                            FolderIconView(
                                                resolutionScale: 0.125
                                            )
                                            .frame(width: 100, height: 100)
                                            .scaleEffect(0.21)
                                        }
                                    }
                                }.opacity(foldersViewModel.isTargetedDrop ? 1 : 0)
                                    .animation(.default, value: foldersViewModel.isTargetedDrop)
                            }
                            .onDrop(of: ["public.file-url"], isTargeted: $foldersViewModel.isTargetedDrop) { providers in
                                handleDrop(providers: providers)
                            }
                            
                            // -- Colors
                            HStack {
                                Text("Colors")
                                    .font(.system(.title, design: .rounded, weight: .bold))
                                    .foregroundStyle(Color.white)
                                Spacer()
                            }.padding(.top, 20)
                            
                            HStack {
                                VStack(alignment: .center) {
                                    Text("Base")
                                    ColorWell(color: $bottomShapeColor)
                                        .onChange(of: bottomShapeColor) { oldValue, newValue in
                                            bottomShapeColorIsUpdating = true
                                            foldersViewModel.bottomShapeColor = newValue
                                            print("Updating 1")
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                                bottomShapeColorIsUpdating = false
                                            }
                                        }
                                        .onChange(of: foldersViewModel.bottomShapeColor) { oldValue, newValue in
                                            if !bottomShapeColorIsUpdating {
                                                bottomShapeColor = newValue
                                                print("Updating 2")
                                            }
                                        }
                                }
                                .padding(.trailing, 20)
                                
                                VStack(alignment: .center) {
                                    Text("Tab")
                                    ColorWell(color: $topShapeColor)
                                        .onChange(of: topShapeColor) { oldValue, newValue in
                                            topShapeColorIsUpdating = true
                                            foldersViewModel.topShapeColor = newValue
                                            print("Updating 1")
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                                topShapeColorIsUpdating = false
                                            }
                                        }
                                        .onChange(of: foldersViewModel.topShapeColor) { oldValue, newValue in
                                            if !topShapeColorIsUpdating {
                                                topShapeColor = newValue
                                                print("Updating 2")
                                            }
                                        }
                                }
                                .padding(.trailing, 20)
                                
                                VStack(alignment: .center) {
                                    Text("Symbol")
                                    ColorWell(color: $symbolColor)
                                        .onChange(of: symbolColor) { oldValue, newValue in
                                            symbolColorIsUpdating = true
                                            foldersViewModel.symbolColor = newValue
                                            print("Updating 1")
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                                symbolColorIsUpdating = false
                                            }
                                        }
                                        .onChange(of: foldersViewModel.symbolColor) { oldValue, newValue in
                                            if !symbolColorIsUpdating {
                                                symbolColor = newValue
                                                print("Updating 2")
                                            }
                                        }
                                }
                                .padding(.trailing, 20)
                            }.frame(height: 50)
                                .onAppear() {
                                    bottomShapeColor = foldersViewModel.bottomShapeColor
                                    topShapeColor = foldersViewModel.topShapeColor
                                    symbolColor = foldersViewModel.symbolColor
                                }
                        }
                    }.frame(width: 300)

                    Spacer()
                        .frame(width: 20)
                    
                    GeometryReader { rightGeo in
                        // MARK: - Controls
                        //ScrollView {
                            VStack(alignment: .center, spacing: 20) {
                                // -- Image Type
                                HStack {
                                    Text("Type:")
                                        .font(.system(.title, design: .rounded, weight: .bold))
                                        .foregroundStyle(Color.white)
                                    
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
                                                Text("None")
                                                    .frame(width: pickerGeo.size.width/3)
                                                
                                                Text("Image")
                                                    .frame(width: pickerGeo.size.width/3)
                                                
                                                Text("SF Symbol")
                                                    .frame(width: pickerGeo.size.width/3)
                                            }.foregroundStyle(Color.white)
                                            
                                            HStack(spacing: 0) {
                                                Color.white.opacity(0.001)
                                                    .frame(width: pickerGeo.size.width/3, height: 30)
                                                    .onTapGesture {
                                                        foldersViewModel.imageType = .none
                                                    }
                                                
                                                Color.white.opacity(0.001)
                                                    .frame(width: pickerGeo.size.width/3, height: 30)
                                                    .onTapGesture {
                                                        foldersViewModel.imageType = .png
                                                    }
                                                
                                                Color.white.opacity(0.001)
                                                    .frame(width: pickerGeo.size.width/3, height: 30)
                                                    .onTapGesture {
                                                        foldersViewModel.imageType = .sfsymbol
                                                    }
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
                                                    selectImageFile()
                                                } label: {
                                                    Text(foldersViewModel.selectedImage != nil ? "Change": "Select")
                                                }
                                                .buttonStyle(SmallButton3DStyle())
                                                .frame(width: 100, height: 30)
                                            }
                                            else if foldersViewModel.imageType == .sfsymbol {
                                                VStack(alignment: .center) {
                                                    Image(systemName: foldersViewModel.symbolName)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .foregroundStyle(Color(hex: "78D6FF"))
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
                                                                    Text("Close")
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
                                        
                                        ScrollView {
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
                                                                    Text("Standard")
                                                                        .frame(width: advancedImagePicker.size.width/2)
                                                                    
                                                                    Text("Advanced")
                                                                        .frame(width: advancedImagePicker.size.width/2)
                                                                }.foregroundStyle(Color.white)
                                                                
                                                                HStack(spacing: 0) {
                                                                    Color.white.opacity(0.001)
                                                                        .frame(width: advancedImagePicker.size.width/2, height: 30)
                                                                        .onTapGesture {
                                                                            foldersViewModel.useAdvancedIconRendering = false
                                                                        }
                                                                    
                                                                    Color.white.opacity(0.001)
                                                                        .frame(width: advancedImagePicker.size.width/2, height: 30)
                                                                        .onTapGesture {
                                                                            foldersViewModel.useAdvancedIconRendering = true
                                                                        }
                                                                }
                                                                
                                                            }
                                                            
                                                        }
                                                    }.padding([.leading, .vertical], 5)
                                                        .padding(.trailing)
                                                        .frame(height: 30)
                                                }
                                                
                                                HStack {
                                                    //                                                Text("Opacity: \(Int(symbolOpacity*100))%")
                                                    Text("Opacity")
                                                    
                                                    Spacer()
                                                    
                                                    Button {
                                                        foldersViewModel.symbolOpacity = 0.5
                                                    } label: {
                                                        Text("Reset")
                                                    }
                                                    .buttonStyle(SmallButton3DStyle())
                                                    .frame(width: 70, height: 30)
                                                    .padding([.top, .bottom])
                                                    
                                                    Button {
                                                        withAnimation {
                                                            foldersViewModel.hideOpacity.toggle()
                                                        }
                                                    } label: {
                                                        Image(systemName: "chevron.down")
                                                            .rotationEffect(Angle(degrees: !foldersViewModel.hideOpacity ? -180: 0))
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
                                                    Text("Scale")
                                                    
                                                    Spacer()
                                                    
                                                    Button {
                                                        foldersViewModel.iconScale = 1.0
                                                    } label: {
                                                        Text("Reset")
                                                    }
                                                    .buttonStyle(SmallButton3DStyle())
                                                    .frame(width: 70, height: 30)
                                                    .padding([.top, .bottom])
                                                    
                                                    Button {
                                                        withAnimation {
                                                            foldersViewModel.hideScale.toggle()
                                                        }
                                                    } label: {
                                                        Image(systemName: "chevron.down")
                                                            .rotationEffect(Angle(degrees: !foldersViewModel.hideScale ? -180: 0))
                                                    }
                                                    .buttonStyle(SmallButton3DStyle())
                                                    .frame(width: 30, height: 30)
                                                    .padding([.top, .bottom, .trailing])
                                                }
                                                
                                                if !foldersViewModel.hideScale {
                                                    CustomSlider(value: $foldersViewModel.iconScale, minValue: 0, maxValue: 5)
                                                        //.frame(width: 200)
                                                        .padding(.horizontal, 5)
                                                }
                                                
                                                Divider()
                                                
                                                HStack {
                                                    Text("Offset")
                                                    
                                                    Spacer()
                                                    
                                                    Button {
                                                        foldersViewModel.iconOffset = 0
                                                        foldersViewModel.iconOffsetX = 0
                                                    } label: {
                                                        Text("Reset")
                                                    }
                                                    .buttonStyle(SmallButton3DStyle())
                                                    .frame(width: 70, height: 30)
                                                    .padding([.top, .bottom])
                                                    
                                                    Button {
                                                        withAnimation {
                                                            foldersViewModel.hideOffset.toggle()
                                                        }
                                                    } label: {
                                                        Image(systemName: "chevron.down")
                                                            .rotationEffect(Angle(degrees: !foldersViewModel.hideOffset ? -180: 0))
                                                    }
                                                    .buttonStyle(SmallButton3DStyle())
                                                    .frame(width: 30, height: 30)
                                                    .padding([.top, .bottom, .trailing])
                                                }
                                                .onChange(of: pos) { oldValue, newValue in
                                                    foldersViewModel.iconOffset = newValue[1]
                                                    foldersViewModel.iconOffsetX = newValue[0]
                                                    //print("Updating thing 1")
                                                }
                                                .onChange(of: foldersViewModel.iconOffset + foldersViewModel.iconOffsetX) { oldValue, newValue in
                                                    pos = [foldersViewModel.iconOffsetX, foldersViewModel.iconOffset]
                                                    //print("Updating thing 2")
                                                }
                                                
                                                if !foldersViewModel.hideOffset {
//                                                    CustomSlider2(value: $foldersViewModel.iconOffset, minValue: 200, maxValue: -200)
//                                                        .padding(.horizontal, 5)
                                                    
                                                    
                                                    AxisPicker(
                                                        coords: $pos,
                                                        xMin: -200,  xMax: 200,
                                                        yMin: -200,  yMax: 200
                                                    )
                                                    .padding(.horizontal, 5)
                                                }
                                                //                                            Custom2DSlider(valueX: $plane2DTest, valueY: $iconOffset, minValueX: 0, maxValueX: 5, minValueY: -200, maxValueY: 200)
                                            }//.frame(width: 210)
                                        }//.frame(width: 210)
                                        Spacer()
                                    }
                                    
                                }
                            }
                            .frame(width: rightGeo.size.width)
                        //}
                        .zIndex(1)
                    }
                }
                .padding([.horizontal, .top], 20)
                .frame(minHeight: 300, idealHeight: 500)
            }
        }
        .frame(minWidth: 850, minHeight: 500)
//        .environmentObject(foldersViewModel)
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
    
    private func selectImageFile() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.image, .png, .svg]
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        
        if panel.runModal() == .OK, let url = panel.url {
            if let image = NSImage(contentsOf: url) {
                foldersViewModel.selectedImage = image
            } else {
                print("Failed to load the selected PNG file.")
            }
        }
    }
    
    
    // MARK: - Save as PNG to user-chosen location
    private func savePNG() {
        let panel = NSSavePanel()
        panel.canCreateDirectories = true
        panel.allowedContentTypes = [.png]
        panel.nameFieldStringValue = "FolderIcon.png"
        
        if panel.runModal() == .OK, let url = panel.url {
            // 1) Render a 470×395 icon at 100% scale
            let fullSizeIcon = FolderIconView(
                resolutionScale: 1.0
            )
            
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
            resolutionScale: 1.0
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
