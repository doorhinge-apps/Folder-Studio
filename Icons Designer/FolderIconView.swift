import SwiftUI

struct FolderIconView: View {
    // Bindings from the parent (ContentView)
    @Binding var topShapeColor: Color
    @Binding var bottomShapeColor: Color
    @Binding var symbolName: String
    @Binding var symbolColor: Color
    @Binding var symbolOpacity: Double
    @Binding var topOffset: CGFloat
    @Binding var bottomOffset: CGFloat
    
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
                
                Image(systemName: symbolName)
                    .resizable()
                    .scaledToFit()
//                    .foregroundColor(symbolColor)
                    .foregroundStyle(symbolColor.shadow(.inner(color: Color(.black).opacity(0.25), radius: 10)))
                    .opacity(symbolOpacity)   // user slider
                    .frame(width: 150, height: 150)
                    .position(x: iconWidth / 2, y: 231)
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
