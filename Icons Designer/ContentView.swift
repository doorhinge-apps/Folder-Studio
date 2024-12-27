import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = IconDesignerViewModel()
    
    // The color to blend with the SVG
    @State private var svgColor: Color = .red
    
    var body: some View {
        VStack(spacing: 20) {
            
            // MARK: - Preview
            if let finalImage = viewModel.generateFinalIcon() {
                // Display the final image with blending and opacity
                Image(nsImage: finalImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .blending(color: svgColor) // Apply the provided blending modifier
                    .opacity(0.5) // Set entire image to 50% opacity
                    .frame(height: 200) // Scale to 200px tall
                    .border(Color.gray, width: 1)
            } else {
                Text("No SVG loaded")
                    .foregroundColor(.secondary)
            }
            
            // MARK: - Load SVG & SVG Color Picker
            HStack {
                Button("Load SVG") {
                    openPanelAndLoadSVG()
                }
                .padding(.trailing, 20)
                
                ColorPicker("SVG Color", selection: $svgColor)
                    .frame(width: 150)
            }
            
            // MARK: - Shape Colors
            HStack {
                ColorPicker("Top Shape Color", selection: $viewModel.topShapeColor)
                    .frame(width: 150)
                
                ColorPicker("Bottom Shape Color", selection: $viewModel.bottomShapeColor)
                    .frame(width: 150)
            }
            
            // MARK: - Offset Sliders with Plus/Minus Buttons
            VStack(spacing: 20) {
                // Bottom Rectangle Offset
                HStack {
                    Button("-") {
                        viewModel.bottomOffset -= 1
                    }
                    .frame(width: 30, height: 30)
                    
                    Slider(value: $viewModel.bottomOffset, in: -470...470, step: 1)
                        .frame(width: 300)
                    
                    Button("+") {
                        viewModel.bottomOffset += 1
                    }
                    .frame(width: 30, height: 30)
                }
                Text("Bottom Offset: \(Int(viewModel.bottomOffset))")
                    .frame(width: 400, alignment: .leading)
                
                // Top Shape Offset
                HStack {
                    Button("-") {
                        viewModel.topOffset -= 1
                    }
                    .frame(width: 30, height: 30)
                    
                    Slider(value: $viewModel.topOffset, in: -470...470, step: 1)
                        .frame(width: 300)
                    
                    Button("+") {
                        viewModel.topOffset += 1
                    }
                    .frame(width: 30, height: 30)
                }
                Text("Top Offset: \(Int(viewModel.topOffset))")
                    .frame(width: 400, alignment: .leading)
            }
            .padding()
            .frame(width: 400)
            
            // MARK: - Save PNG
            Button("Save PNG") {
                savePNG()
            }
            .padding(.top, 20)
        }
        .padding()
        .frame(minWidth: 600, minHeight: 600)
    }
    
    // MARK: - File/Open Panels
    
    private func openPanelAndLoadSVG() {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["svg"]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        
        if panel.runModal() == .OK, let url = panel.url {
            viewModel.loadSVG(from: url)
        }
    }
    
    private func savePNG() {
        let panel = NSSavePanel()
        panel.allowedFileTypes = ["png"]
        panel.nameFieldStringValue = "Icon.png"
        
        if panel.runModal() == .OK, let url = panel.url {
            viewModel.saveFinalIcon(to: url)
        }
    }
}

// MARK: - ColorBlended ViewModifier

public struct ColorBlended: ViewModifier {
    fileprivate var color: Color
    
    public func body(content: Content) -> some View {
        VStack {
            ZStack {
                content
                color.blendMode(.sourceAtop)
            }
            .drawingGroup(opaque: false)
        }
    }
}

extension View {
    public func blending(color: Color) -> some View {
        modifier(ColorBlended(color: color))
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
