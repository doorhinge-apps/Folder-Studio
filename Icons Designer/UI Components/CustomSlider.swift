import SwiftUI

struct CustomSlider<T: BinaryFloatingPoint & Equatable>: View {
    @Binding var value: T
    var minValue: Double
    var maxValue: Double
    
    var trackHeight: CGFloat = 25
    var handleSize: CGFloat = 30
    var trailingMargin: CGFloat = 10
    var strokeWidth: CGFloat = 4

    var body: some View {
        GeometryReader { geometry in
            let sliderWidth = geometry.size.width - handleSize - trailingMargin
            let progress = (Double(value) - minValue) / (maxValue - minValue)
            let fillWidth = (handleSize / 2) + CGFloat(progress) * sliderWidth
            let handleOffset = CGFloat(progress) * sliderWidth

            ZStack(alignment: .leading) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: trackHeight / 2)
                        .fill(Color(hex: "78D6FF"))
                        .frame(height: trackHeight)

                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color(hex: "4C7C97").opacity(0.75))
                        .frame(width: max(0, min(geometry.size.width - trailingMargin, fillWidth)),
                               height: trackHeight)
                }
                .frame(width: geometry.size.width - trailingMargin)
                .mask {
                    RoundedRectangle(cornerRadius: trackHeight / 2)
                        .frame(height: trackHeight)
                }
                .overlay {
                    ZStack {
                        RoundedRectangle(cornerRadius: trackHeight / 2)
                            .stroke(Color.black.opacity(0.7), lineWidth: strokeWidth)
                            .frame(height: trackHeight)
                            .blur(radius: 5)
                            .mask {
                                RoundedRectangle(cornerRadius: trackHeight / 2)
                                    .frame(height: trackHeight)
                            }
                        RoundedRectangle(cornerRadius: trackHeight / 2)
                            .stroke(Color(hex: "1E8CCB"), lineWidth: strokeWidth)
                            .frame(height: trackHeight)
                    }
                }

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
                .offset(x: handleOffset)
            }
            .contentShape(Rectangle())
            .background(Color.clear)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { drag in
                        let sliderWidth = geometry.size.width - handleSize - trailingMargin
                        let minCenter = handleSize / 2
                        let maxCenter = sliderWidth + handleSize / 2
                        let clampedX = min(max(drag.location.x, minCenter), maxCenter)
                        let computedProgress = (clampedX - minCenter) / sliderWidth
                        self.value = T(minValue + Double(computedProgress) * (maxValue - minValue))
                    }
            )
        }
        .frame(height: handleSize * 2)

        // MARK: - Accessibility representation (macOS 14+)
        .accessibilityRepresentation {
            Slider(
                value: Binding(
                    get: { Double(value) },
                    set: { value = T($0) }
                ),
                in: minValue...maxValue
            ) {
//                Text("accessibility_slider_label")
            }
            .accessibilityValue(Text("\(Int(Double(value) * 100)) %"))
        }
//        .focusable(true)
    }
}
