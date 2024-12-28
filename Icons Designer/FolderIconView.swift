import SwiftUI

enum ImageType: String, Equatable, CaseIterable {
    case png = "PNG"
    case svg = "SVG"
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
    
    @Binding var imageType: ImageType
    
    // Final icon dimensions
    private let iconWidth: CGFloat = 470
    private let iconHeight: CGFloat = 395
    
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
                
                if imageType == .sfsymbol {
                    Image(systemName: symbolName)
                        .resizable()
                        .scaledToFit()
                    //                    .foregroundColor(symbolColor)
                        .foregroundStyle(symbolColor.shadow(.inner(color: Color(.black).opacity(0.25), radius: 10)))
                        .opacity(symbolOpacity)   // user slider
                        .frame(width: 150, height: 150)
                        .position(x: iconWidth / 2, y: 231)
                }
                
                if imageType == .svg || imageType == .png {
                    ZStack {
                        Image("PNKey")
                            .resizable()
                            .scaledToFit()
                        //                    .foregroundColor(symbolColor)
                            .foregroundStyle(.shadow(.inner(color: Color(.black).opacity(0.25), radius: 10)))
                            .opacity(symbolOpacity)
                            .frame(width: 150, height: 150)
                            .position(x: iconWidth / 2, y: 231)
                        
                        symbolColor.blendMode(.sourceAtop)
                    }.drawingGroup(opaque: false)
                }
            }
        }
        .overlay(content: {
            Image("Grainy Grain")
                .ignoresSafeArea()
                .opacity(0.15)
        })
        .clipped()
        .frame(width: iconWidth, height: iconHeight)
    }
}


#Preview {
    FolderIconView(topShapeColor: .constant(Color(hex: "1E8CCB")),
                   bottomShapeColor: .constant(Color(hex: "6FCDF6")),
                   symbolName: .constant("star.fill"),
                   symbolColor: .constant(Color(hex: "1E8CCB")),
                   symbolOpacity: .constant(0.5),
                   topOffset: .constant(-141),
                   bottomOffset: .constant(-81), imageType: .constant(.png))
}
