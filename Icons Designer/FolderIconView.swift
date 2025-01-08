import SwiftUI

enum ImageType: String, Equatable, CaseIterable {
    case none = "None"
    case png = "Image"
//    case svg = "SVG"
    case sfsymbol = "SF Symbol"

    var localizedName: String { rawValue }
}

struct FolderIconView: View {
    // Bindings from the parent (ContentView)
    @Binding var topShapeColor: Color
    @Binding var bottomShapeColor: Color
    @Binding var symbolName: String
    @Binding var symbolColor: Color
    @Binding var symbolOpacity: Double
    @Binding var topOffset: CGFloat
    @Binding var bottomOffset: CGFloat
    
    @Binding var iconOffset: CGFloat
    
    @Binding var iconScale: Double
    
    @Binding var imageType: ImageType
    
    // Final icon dimensions
    private let iconWidth: CGFloat = 470
    private let iconHeight: CGFloat = 395
    
    @Binding var customImage: NSImage?
    
    var body: some View {
        ZStack {
            FolderHat()
//                .fill(topShapeColor)
                .fill(topShapeColor.shadow(.inner(color: .white, radius: 10)))
                .frame(width: iconWidth, height: 114)
                .offset(y: topOffset)
            
            ZStack {
                RoundedRectangle(cornerRadius: 35, style: .continuous)
//                    .fill(bottomShapeColor)
                    .fill(bottomShapeColor.shadow(.inner(color: .white, radius: 10)))
                    .frame(width: iconWidth, height: 328)
                    .offset(y: 114 + bottomOffset)
                
                if imageType == .none || customImage == nil {
                    Spacer()
                        .foregroundStyle(symbolColor.shadow(.inner(color: Color(.black).opacity(0.5), radius: 10)))
                        .opacity(symbolOpacity)
                        .frame(width: 150, height: 150)
                        .position(x: iconWidth / 2, y: 231)
                        .scaleEffect(iconScale)
                        .offset(y: iconOffset)
                }
                
                if imageType == .sfsymbol {
                    Image(systemName: symbolName)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(symbolColor.shadow(.inner(color: Color(.black).opacity(0.5), radius: 10)))
                        .opacity(symbolOpacity)
                        .frame(width: 150, height: 150)
                        .position(x: iconWidth / 2, y: 231)
                        .scaleEffect(iconScale)
                        .offset(y: iconOffset)
                }
                
                if imageType == .png, let image = customImage {
                    ZStack {
                        ZStack {
                            Image(nsImage: image)
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.shadow(.inner(color: Color(.black).opacity(0.5), radius: 10)))
                                .opacity(symbolOpacity)
                                .frame(width: 150, height: 150)
                                .position(x: iconWidth / 2, y: 231)
                                .scaleEffect(iconScale)
                                .offset(y: iconOffset)
                            
                            symbolColor.blendMode(.sourceAtop)
                        }.drawingGroup(opaque: false)
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
}
