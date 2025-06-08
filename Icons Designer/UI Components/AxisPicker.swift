import SwiftUI
import AppKit   // Shift-key check, VO announcement

// -------- helper extensions ----------
fileprivate extension Array {
    subscript(safe i: Int) -> Element? { indices.contains(i) ? self[i] : nil }
}
private enum LockAxis { case horizontal, vertical, diagonal }
// --------------------------------------

struct AxisPicker: View {
    @Binding var coords: [CGFloat]          // [x, y] — y grows *down* internally
    let xMin: CGFloat, xMax: CGFloat
    let yMin: CGFloat, yMax: CGFloat        // e.g. −100 … +100  (top = −100)

    var handleSize: CGFloat = 30
    var strokeWidth: CGFloat = 4
    
    @State private var dragLockedAxis: LockAxis?
    @State private var initialCenter: CGPoint?
    
    private let knobRadius: CGFloat = 10
    private var xSpan: CGFloat { xMax - xMin }
    private var ySpan: CGFloat { yMax - yMin }
    private func clamp(_ v: CGFloat, _ lo: CGFloat, _ hi: CGFloat) -> CGFloat { min(max(v, lo), hi) }
    
    // ------------- BODY (unchanged visuals) -------------
    var body: some View {
        GeometryReader { geo in
            let side  = min(geo.size.width, geo.size.height)
            let track = side - knobRadius * 2

            let nx = ((coords[safe:0] ?? xMin) - xMin) / xSpan
            let ny = ((coords[safe:1] ?? yMin) - yMin) / ySpan
            let cx = clamp(nx * track + knobRadius, knobRadius, side - knobRadius)
            let cy = clamp(ny * track + knobRadius, knobRadius, side - knobRadius)

            ZStack {
                RoundedRectangle(cornerRadius: 12.5)
                    .fill(Color(hex: "78D6FF"))
                    .overlay {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12.5)
                                .stroke(Color.black.opacity(0.7), lineWidth: strokeWidth)
                                .blur(radius: 5)
                                .mask { RoundedRectangle(cornerRadius: 12.5) }
                            RoundedRectangle(cornerRadius: 12.5)
                                .stroke(Color(hex: "1E8CCB"), lineWidth: strokeWidth)
                        }
                    }
                
                ZStack {
                    Circle()
                        .fill(Color(hex: "4C7C97"))
                        .frame(width: handleSize, height: handleSize)
                        .shadow(radius: 2, x: 1, y: 1)
                    Circle()
                        .fill(Color(hex: "4C7C97")
                              .shadow(.inner(color: .black.opacity(0.3), radius: 4)))
                        .frame(width: handleSize - strokeWidth * 2,
                               height: handleSize - strokeWidth * 2)
                }
                .position(x: cx, y: cy)
                .gesture(dragGesture(side: side, track: track))
            }
            .frame(width: side, height: side)
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear { if coords.count != 2 { coords = [xMin, yMin] } }
        
        // ---------- ACCESSIBILITY ----------
        
        // keyboard (root view focused)
        .focusable(true)
        .onMoveCommand(perform: handleMoveCommand)
        
        // VO / Switch Control
        .accessibilityRepresentation { slidersForVO }
    }
    
    // -------- drag logic (unchanged) --------
    private func dragGesture(side: CGFloat, track: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged { g in
                let shift = NSEvent.modifierFlags.contains(.shift)
                
                if initialCenter == nil {
                    initialCenter = CGPoint(x: (coords[safe:0] ?? 0) , y: (coords[safe:1] ?? 0))
                    dragLockedAxis = nil
                }
                
                var tx = clamp(g.location.x, knobRadius, side - knobRadius)
                var ty = clamp(g.location.y, knobRadius, side - knobRadius)
                
                if shift, let start = initialCenter {
                    // … axis-locking code unchanged …
                }
                
                let newX = (tx - knobRadius) / track * xSpan + xMin
                let newY = (ty - knobRadius) / track * ySpan + yMin
                coords = [newX, newY]
            }
            .onEnded { _ in initialCenter = nil; dragLockedAxis = nil }
    }
    
    // -------- keyboard arrows (Y inverted & announcement) --------
    private func handleMoveCommand(_ dir: MoveCommandDirection) {
        let stepX = xSpan / 20
        let stepY = ySpan / 20
        
        switch dir {
        case .left:
            coords[0] = clamp((coords[safe:0] ?? xMin) - stepX, xMin, xMax)
        case .right:
            coords[0] = clamp((coords[safe:0] ?? xMin) + stepX, xMin, xMax)
        case .up:   // top is positive to the user ⇒ decrease stored Y
            coords[1] = clamp((coords[safe:1] ?? yMin) - stepY, yMin, yMax)
        case .down: // bottom is negative to the user ⇒ increase stored Y
            coords[1] = clamp((coords[safe:1] ?? yMin) + stepY, yMin, yMax)
        default: break
        }
        
        announce()
    }
    
    // -------- VoiceOver sliders --------
    private var slidersForVO: some View {
        VStack(spacing: 8) {
            Slider(
                value: Binding(
                    get: { Double(coords[safe:0] ?? xMin) },
                    set: { coords[0] = CGFloat($0) }
                ),
                in: xMin...xMax
            ) { Text("X axis") }
            
            Slider(
                value: Binding(
                    get: { Double(coords[safe:1] ?? yMin) },
                    set: { coords[1] = CGFloat($0) }
                ),
                in: yMin...yMax
            ) { Text("Y axis") }
            // Speak inverted Y so top = positive
            .accessibilityValue(Text("\(Int(-(coords[safe:1] ?? 0)))"))
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("2-D picker")
    }
    
    // -------- VO announcement helper --------
    private func announce() {
        let xVal = Int(coords[safe:0] ?? 0)
        let yVal = Int(-(coords[safe:1] ?? 0))   // inverted for speech
        let announcement = "X: \(xVal), Y: \(yVal)"
        
        NSAccessibility.post(
            element: NSApp,
            notification: .announcementRequested,
            userInfo: [.announcement : announcement]
        )
    }
}
