import SwiftUI

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
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
//                    Text((1 - 395 / geo.size.height).description)
                    
                    // MARK: - Live Preview
                    // Show the folder icon at a smaller scale, if desired
                    FolderIconView(topShapeColor: $topShapeColor,
                                   bottomShapeColor: $bottomShapeColor,
                                   symbolName: $symbolName,
                                   symbolColor: $symbolColor,
                                   symbolOpacity: $symbolOpacity,
                                   topOffset: $topOffset,
                                   bottomOffset: $bottomOffset)
                    .scaleEffect(1 - 395 / geo.size.height)
                    .frame(height: (1 - 395 / geo.size.height) * geo.size.height)
                    .clipped()
                    
                    // MARK: - SF Symbol Controls
                    HStack {
                        VStack(alignment: .leading) {
                            Text("SF Symbol Name:")
//                            TextField("e.g. star.fill", text: $symbolName)
//                                .textFieldStyle(RoundedBorderTextFieldStyle())
//                                .frame(width: 150)
                            Button {
                                showIconPicker = true
                            } label: {
                                Text(symbolName)
                            }
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
                            Text("Symbol Color:")
                            ColorPicker("", selection: $symbolColor)
                                .labelsHidden()
                                .frame(width: 50)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Opacity: \(String(format: "%.2f", symbolOpacity))")
                            
                            Slider(value: $symbolOpacity, in: 0...1, step: 0.01)
                                .frame(width: 150)
                        }
                    }
                    
                    // MARK: - Shape Colors
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Folder Tab Color:")
                            ColorPicker("", selection: $topShapeColor)
                                .labelsHidden()
                                .frame(width: 50)
                        }
                        .padding(.trailing, 20)
                        
                        VStack(alignment: .leading) {
                            Text("Folder Bottom Color:")
                            ColorPicker("", selection: $bottomShapeColor)
                                .labelsHidden()
                                .frame(width: 50)
                        }
                    }
                    
                    // MARK: - Save
                    Button(action: savePNG) {
                        Text("Save PNG")
                            .font(.headline)
                            .padding()
                            .frame(width: 200)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 10)
                    
                    Text("Preset Colors")
                        .font(.system(.title2, design: .default, weight: .medium))
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .center) {
                            FolderPresetPreview(color1: "1E8CCB", color2: "6FCDF6", symbolName: $symbolName, topOffset: $topOffset, bottomOffset: $bottomOffset, topShapeColorSetter: $topShapeColor, bottomShapeColorSetter: $bottomShapeColor, iconColorSetter: $symbolColor, opacitySetter: $symbolOpacity)
                            
                            FolderPresetPreview(color1: "D23359", color2: "F66F8F", symbolName: $symbolName, topOffset: $topOffset, bottomOffset: $bottomOffset, topShapeColorSetter: $topShapeColor, bottomShapeColorSetter: $bottomShapeColor, iconColorSetter: $symbolColor, opacitySetter: $symbolOpacity)
                            
                            FolderPresetPreview(color1: "DA8521", color2: "F6B86F", symbolName: $symbolName, topOffset: $topOffset, bottomOffset: $bottomOffset, topShapeColorSetter: $topShapeColor, bottomShapeColorSetter: $bottomShapeColor, iconColorSetter: $symbolColor, opacitySetter: $symbolOpacity)
                            
                            FolderPresetPreview(color1: "E1C359", color2: "F6F16F", symbolName: $symbolName, topOffset: $topOffset, bottomOffset: $bottomOffset, topShapeColorSetter: $topShapeColor, bottomShapeColorSetter: $bottomShapeColor, iconColorSetter: $symbolColor, opacitySetter: $symbolOpacity)
                            
                            FolderPresetPreview(color1: "20731D", color2: "43AC40", symbolName: $symbolName, topOffset: $topOffset, bottomOffset: $bottomOffset, topShapeColorSetter: $topShapeColor, bottomShapeColorSetter: $bottomShapeColor, iconColorSetter: $symbolColor, opacitySetter: $symbolOpacity)
                            
                            FolderPresetPreview(color1: "2955AB", color2: "5788E5", symbolName: $symbolName, topOffset: $topOffset, bottomOffset: $bottomOffset, topShapeColorSetter: $topShapeColor, bottomShapeColorSetter: $bottomShapeColor, iconColorSetter: $symbolColor, opacitySetter: $symbolOpacity)
                            
                            FolderPresetPreview(color1: "7125BD", color2: "A750FF", symbolName: $symbolName, topOffset: $topOffset, bottomOffset: $bottomOffset, topShapeColorSetter: $topShapeColor, bottomShapeColorSetter: $bottomShapeColor, iconColorSetter: $symbolColor, opacitySetter: $symbolOpacity)
                            
                            FolderPresetPreview(color1: "BD2593", color2: "FA62F4", symbolName: $symbolName, topOffset: $topOffset, bottomOffset: $bottomOffset, topShapeColorSetter: $topShapeColor, bottomShapeColorSetter: $bottomShapeColor, iconColorSetter: $symbolColor, opacitySetter: $symbolOpacity)
                        }.padding(.horizontal, 10)
                    }
                }.frame(width: geo.size.width)
            }
        }.frame(minWidth: 500, minHeight: 500)
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
    
    // MARK: - Save Function
    private func savePNG() {
        // Create a panel
        let panel = NSSavePanel()
        panel.canCreateDirectories = true
        panel.allowedFileTypes = ["png"]
        panel.nameFieldStringValue = "FolderIcon.png"
        
        if panel.runModal() == .OK, let url = panel.url {
            // Snapshot the full 470×395 icon at 100% scale
            let fullSizeIcon = FolderIconView(topShapeColor: $topShapeColor,
                                              bottomShapeColor: $bottomShapeColor,
                                              symbolName: $symbolName,
                                              symbolColor: $symbolColor,
                                              symbolOpacity: $symbolOpacity,
                                              topOffset: $topOffset,
                                              bottomOffset: $bottomOffset)
            
            let nsImage = fullSizeIcon.snapshotAsNSImage()
            
            // Convert NSImage -> PNG data
            guard let tiffData = nsImage.tiffRepresentation,
                  let bitmap = NSBitmapImageRep(data: tiffData),
                  let pngData = bitmap.representation(using: .png, properties: [:]) else {
                return
            }
            // Write out
            do {
                try pngData.write(to: url)
            } catch {
                print("Failed to save: \(error)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
