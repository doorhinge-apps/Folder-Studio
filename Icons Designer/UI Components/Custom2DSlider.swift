import SwiftUI

struct Custom2DSlider: View {
    @Binding var valueX: CGFloat
    @Binding var valueY: CGFloat
    
    @State var minValueX: Double
    @State var maxValueX: Double
    @State var minValueY: Double
    @State var maxValueY: Double
    
    var trackHeight: CGFloat = 25
    var handleSize: CGFloat = 30
    var trailingMargin: CGFloat = 10
    var strokeWidth: CGFloat = 4

    var body: some View {
        GeometryReader { geometry in
            let planeWidth = geometry.size.width - handleSize * 2 - trailingMargin * 2
            let planeHeight = geometry.size.height - handleSize * 2 - trailingMargin * 2
            
            ZStack(alignment: .center) {
                // MARK: - Plane
                Rectangle()
                    .fill(Color(hex: "78D6FF"))
                    .frame(width: geometry.size.width,
                           height: geometry.size.height)
                
                Rectangle()
                    .stroke(Color.black.opacity(0.7), lineWidth: strokeWidth)
                    .frame(width: planeWidth, height: planeHeight)
                
                Rectangle()
                    .stroke(Color(hex: "1E8CCB"), lineWidth: strokeWidth)
                    .frame(width: planeWidth,
                           height: planeHeight)
                
                // MARK: - Handles
                ZStack {
                    Circle()
                        .fill(Color(hex: "4C7C97"))
                        .frame(width: handleSize, height: handleSize)
                        .shadow(color: .gray, radius: 2, x: 1, y: 1)
                    
                    Circle()
                        .fill(Color(hex: "4C7C97")
                            .shadow(.inner(color: Color.black.opacity(0.3), radius: 4)))
                        .frame(width: handleSize - strokeWidth * 2,
                               height: handleSize - strokeWidth * 2)
                }
                .position(x: valueX + (handleSize / 2),
                          y: valueY + (handleSize / 2))
                
                // MARK: - Constraints / Edges
                Rectangle()
                    .fill(Color(hex: "78D6FF"))
                    .frame(width: trailingMargin, height: geometry.size.height)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { drag in
                                self.valueX = maxValueX + (drag.location.x - handleSize) * (maxValueX - minValueX) / planeWidth
                            }
                    )
                Rectangle()
                    .fill(Color(hex: "78D6FF"))
                    .frame(width: geometry.size.width, height: trailingMargin)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { drag in
                                self.valueY = maxValueY + (drag.location.y - handleSize) * (maxValueY - minValueY) / planeHeight
                            }
                    )
                Rectangle()
                    .fill(Color(hex: "78D6FF"))
                    .frame(width: trailingMargin, height: geometry.size.height)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { drag in
                                self.valueX = minValueX + (drag.location.x - handleSize) * (maxValueX - minValueX) / planeWidth
                            }
                    )
                Rectangle()
                    .fill(Color(hex: "78D6FF"))
                    .frame(width: geometry.size.width, height: trailingMargin)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { drag in
                                self.valueY = minValueY + (drag.location.y - handleSize) * (maxValueY - minValueY) / planeHeight
                            }
                    )
            }
//            .accessibilityElement()
//            .accessibilityCustomContent("X", Text("\(valueX)"))
//            .accessibilityCustomContent("Y", Text("\(valueY)"))
            .contentShape(Rectangle())
            .frame(height: geometry.size.height)
            .focusable(true)
            .onMoveCommand { direction in
                let stepX = (maxValueX - minValueX) / 20
                let stepY = (maxValueY - minValueY) / 20
                switch direction {
                case .left:
                    valueX = CGFloat(max(Double(valueX) - stepX, minValueX))
                case .right:
                    valueX = CGFloat(min(Double(valueX) + stepX, maxValueX))
                case .up:
                    valueY = CGFloat(max(Double(valueY) - stepY, minValueY))
                case .down:
                    valueY = CGFloat(min(Double(valueY) + stepY, maxValueY))
                default: break
                }
            }
            .accessibilityRepresentation {
                VStack {
                    Slider(
                        value: Binding(get: { Double(valueX) }, set: { valueX = CGFloat($0) }),
                        in: minValueX...maxValueX
                    ) {
                        Text("X axis")
                    }
                    .accessibilityLabel("X axis")
                    .accessibilityValue(Text("\(Int(valueX))"))

                    Slider(
                        value: Binding(get: { Double(valueY) }, set: { valueY = CGFloat($0) }),
                        in: minValueY...maxValueY
                    ) {
                        Text("Y axis")
                    }
                    .accessibilityLabel("Y axis")
                    .accessibilityValue(Text("\(Int(valueY))"))
                }
            }

//            .accessibilityLabel("2D Slider")
//            .accessibilityCustomContent(AccessibilityCustomContentKey("X"), String(valueX))
//            .accessibilityCustomContent(AccessibilityCustomContentKey("Y"), String(valueY))
//            .accessibilityCustomContent("X", value: Int(valueX))
//            .accessibilityCustomContent("Y", value: Int(valueY))
        }
    }
}
