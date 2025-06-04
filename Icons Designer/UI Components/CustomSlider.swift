import SwiftUI

struct CustomSlider<T: BinaryFloatingPoint & Equatable>: View {
    @Binding var value: T
    @State var minValue: Double
    @State var maxValue: Double
    
    var trackHeight: CGFloat = 25
    var handleSize: CGFloat = 30
    var trailingMargin: CGFloat = 10
    var strokeWidth: CGFloat = 4

    var body: some View {
        GeometryReader { geometry in
            // Compute common values:
            // sliderWidth: the horizontal distance over which the handle's center can move.
            let sliderWidth = geometry.size.width - handleSize - trailingMargin
            // progress: a value between 0 and 1.
            let progress = (Double(value) - minValue) / (maxValue - minValue)
            // fillWidth: should be exactly up to the handle’s center.
            let fillWidth = (handleSize / 2) + CGFloat(progress) * sliderWidth
            
            ZStack(alignment: .leading) {
                // MARK: - Track & Filled Track
                ZStack(alignment: .leading) {
                    // Background Track
                    RoundedRectangle(cornerRadius: trackHeight / 2)
                        .fill(Color(hex: "78D6FF"))
                        .frame(height: trackHeight)
                    
                    // Filled Track – now using fillWidth so it ends at the handle's center.
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
                
                // MARK: - Handle
                // Calculate the handle’s left offset so its center is at (handleSize/2 + progress*sliderWidth).
                let handleOffset = CGFloat(progress) * sliderWidth
                
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
            // Make the entire slider area draggable.
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { drag in
                        // Recompute sliderWidth in case the geometry has changed.
                        let sliderWidth = geometry.size.width - handleSize - trailingMargin
                        // The valid range for the handle’s center:
                        let minCenter = handleSize / 2
                        let maxCenter = sliderWidth + handleSize / 2
                        
                        // Clamp the drag x-coordinate to that range.
                        let clampedX = min(max(drag.location.x, minCenter), maxCenter)
                        // Map the clamped x-coordinate back to a progress value.
                        let computedProgress = (clampedX - minCenter) / sliderWidth
                        self.value = T(minValue + Double(computedProgress) * (maxValue - minValue))
                    }
            )
        }
        .frame(height: handleSize * 2)
    }
}


struct CustomSlider2: View {
    @Binding var value: CGFloat
    @State var minValue: Double
    @State var maxValue: Double
    
    var trackHeight: CGFloat = 25
    var handleSize: CGFloat = 30
    var trailingMargin: CGFloat = 10
    var strokeWidth: CGFloat = 4

    var body: some View {
        GeometryReader { geometry in
            // Compute common values:
            // sliderWidth: the horizontal distance over which the handle's center can move.
            let sliderWidth = geometry.size.width - handleSize - trailingMargin
            // progress: a value between 0 and 1.
            let progress = (value - minValue) / (maxValue - minValue)
            // fillWidth: should be exactly up to the handle’s center.
            let fillWidth = (handleSize / 2) + CGFloat(progress) * sliderWidth
            
            ZStack(alignment: .leading) {
                // MARK: - Track & Filled Track
                ZStack(alignment: .leading) {
                    // Background Track
                    RoundedRectangle(cornerRadius: trackHeight / 2)
                        .fill(Color(hex: "78D6FF"))
                        .frame(height: trackHeight)
                    
                    // Filled Track – now using fillWidth so it ends at the handle's center.
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
                
                // MARK: - Handle
                // Calculate the handle’s left offset so its center is at (handleSize/2 + progress*sliderWidth).
                let handleOffset = CGFloat(progress) * sliderWidth
                
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
            // Make the entire slider area draggable.
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { drag in
                        // Recompute sliderWidth in case the geometry has changed.
                        let sliderWidth = geometry.size.width - handleSize - trailingMargin
                        // The valid range for the handle’s center:
                        let minCenter = handleSize / 2
                        let maxCenter = sliderWidth + handleSize / 2
                        
                        // Clamp the drag x-coordinate to that range.
                        let clampedX = min(max(drag.location.x, minCenter), maxCenter)
                        // Map the clamped x-coordinate back to a progress value.
                        let computedProgress = (clampedX - minCenter) / sliderWidth
                        self.value = minValue + Double(computedProgress) * (maxValue - minValue)
                    }
            )
        }
        .frame(height: handleSize * 2)
    }
}
