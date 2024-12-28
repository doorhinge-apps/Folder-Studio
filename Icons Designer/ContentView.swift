import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = IconDesignerViewModel()

    var body: some View {
        VStack(spacing: 20) {
            
            // MARK: - Preview
            if let finalImage = viewModel.generateFinalIcon() {
                Image(nsImage: finalImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .border(Color.gray, width: 1)
            } else {
                Text("No icon generated yet")
                    .foregroundColor(.secondary)
            }
            
            // MARK: - Symbol Name & Color
            HStack {
                VStack(alignment: .leading) {
                    Text("SF Symbol Name:")
                        .font(.headline)
                    TextField("e.g., star.fill", text: $viewModel.symbolName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 200)
                }
                .padding(.trailing, 40)
                
                VStack(alignment: .leading) {
                    Text("SF Symbol Color:")
                        .font(.headline)
                    ColorPicker("", selection: $viewModel.symbolColor)
                        .labelsHidden()
                        .frame(width: 150)
                }
            }
            
            // MARK: - Symbol Opacity Slider
            VStack(alignment: .leading) {
                Text("Symbol Opacity: \(String(format: "%.2f", viewModel.symbolOpacity))")
                Slider(value: $viewModel.symbolOpacity, in: 0.0...1.0, step: 0.01)
                    .frame(width: 200)
            }
            
            // MARK: - Top/Bottom Shape Colors
            HStack {
                VStack(alignment: .leading) {
                    Text("Top Shape Color:")
                        .font(.headline)
                    ColorPicker("", selection: $viewModel.topShapeColor)
                        .labelsHidden()
                        .frame(width: 150)
                }
                .padding(.trailing, 40)
                
                VStack(alignment: .leading) {
                    Text("Bottom Shape Color:")
                        .font(.headline)
                    ColorPicker("", selection: $viewModel.bottomShapeColor)
                        .labelsHidden()
                        .frame(width: 150)
                }
            }
            
            // MARK: - Offsets
            VStack(spacing: 20) {
                // Bottom Offset
                VStack(alignment: .leading) {
                    Text("Bottom Offset:")
                        .font(.headline)
                    HStack {
                        Button {
                            viewModel.bottomOffset -= 1
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.red)
                        }
                        Slider(value: $viewModel.bottomOffset, in: -470...470, step: 1)
                            .frame(width: 300)
                        Button {
                            viewModel.bottomOffset += 1
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.green)
                        }
                    }
                    Text("\(Int(viewModel.bottomOffset))")
                        .frame(width: 360, alignment: .trailing)
                }
                
                // Top Offset
                VStack(alignment: .leading) {
                    Text("Top Offset:")
                        .font(.headline)
                    HStack {
                        Button {
                            viewModel.topOffset -= 1
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.red)
                        }
                        Slider(value: $viewModel.topOffset, in: -470...470, step: 1)
                            .frame(width: 300)
                        Button {
                            viewModel.topOffset += 1
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.green)
                        }
                    }
                    Text("\(Int(viewModel.topOffset))")
                        .frame(width: 360, alignment: .trailing)
                }
            }
            .padding()
            .frame(width: 400)
            
            // MARK: - Save
            Button {
                savePNG()
            } label: {
                Text("Save PNG")
                    .font(.headline)
                    .padding()
                    .frame(width: 200)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
        }
        .padding()
        .frame(minWidth: 600, minHeight: 700)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
