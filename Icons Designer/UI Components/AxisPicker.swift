import SwiftUI
import AppKit   // for detecting Shift key

// Array safety helper
fileprivate extension Array {
    subscript(safe i: Int) -> Element? { indices.contains(i) ? self[i] : nil }
}

private enum LockAxis { case horizontal, vertical, diagonal }

struct AxisPicker: View {
    @Binding var coords: [CGFloat]
    let xMin: CGFloat
    let xMax: CGFloat
    let yMin: CGFloat
    let yMax: CGFloat

    var handleSize: CGFloat = 30
    var strokeWidth: CGFloat = 4

    @State private var dragLockedAxis: LockAxis? = nil
    @State private var initialCenter: CGPoint? = nil

    private let knobRadius: CGFloat = 10
    private var xSpan: CGFloat { xMax - xMin }
    private var ySpan: CGFloat { yMax - yMin }

    private func clamp(_ v: CGFloat, _ lo: CGFloat, _ hi: CGFloat) -> CGFloat {
        min(max(v, lo), hi)
    }

    public var body: some View {
        GeometryReader { geo in
            let side  = min(geo.size.width, geo.size.height)
            let track = side - knobRadius * 2

            let nx = ((coords[safe: 0] ?? xMin) - xMin) / xSpan
            let ny = ((coords[safe: 1] ?? yMin) - yMin) / ySpan
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
                        .shadow(color: .gray, radius: 2, x: 1, y: 1)

                    Circle()
                        .fill(Color(hex: "4C7C97")
                                .shadow(.inner(color: Color.black.opacity(0.3), radius: 4)))
                        .frame(width: handleSize - strokeWidth * 2,
                               height: handleSize - strokeWidth * 2)
                }
                .position(x: cx, y: cy)
                .gesture(
                    DragGesture()
                        .onChanged { g in
                            let shiftHeld = NSEvent.modifierFlags.contains(.shift)

                            if initialCenter == nil {
                                initialCenter = CGPoint(x: cx, y: cy)
                                dragLockedAxis = nil
                            }

                            var targetX = clamp(g.location.x, knobRadius, side - knobRadius)
                            var targetY = clamp(g.location.y, knobRadius, side - knobRadius)

                            if shiftHeld, let start = initialCenter {
                                let dx = targetX - start.x
                                let dy = targetY - start.y
                                let absDx = abs(dx)
                                let absDy = abs(dy)
                                let dHorizontal = absDy
                                let dVertical   = absDx
                                let dDiagonal   = abs(absDx - absDy)

                                if dragLockedAxis == nil {
                                    if dDiagonal < dHorizontal && dDiagonal < dVertical {
                                        dragLockedAxis = .diagonal
                                    } else if dHorizontal < dVertical {
                                        dragLockedAxis = .horizontal
                                    } else {
                                        dragLockedAxis = .vertical
                                    }
                                }

                                switch dragLockedAxis {
                                case .horizontal:
                                    targetY = start.y
                                case .vertical:
                                    targetX = start.x
                                case .diagonal:
                                    if dx * dy >= 0 {
                                        let rawT = (dx + dy) / 2
                                        let tMin = max(knobRadius - start.x, knobRadius - start.y)
                                        let tMax = min(side - knobRadius - start.x, side - knobRadius - start.y)
                                        let t = clamp(rawT, tMin, tMax)
                                        targetX = start.x + t
                                        targetY = start.y + t
                                    } else {
                                        let rawT = (dx - dy) / 2
                                        let tMin = max(knobRadius - start.x, start.y - (side - knobRadius))
                                        let tMax = min(side - knobRadius - start.x, start.y - knobRadius)
                                        let t = clamp(rawT, tMin, tMax)
                                        targetX = start.x + t
                                        targetY = start.y - t
                                    }
                                case .none:
                                    break
                                }
                            }

                            let newX = (targetX - knobRadius) / track * xSpan + xMin
                            let newY = (targetY - knobRadius) / track * ySpan + yMin
                            coords = [newX, newY]
                        }
                        .onEnded { _ in
                            initialCenter = nil
                            dragLockedAxis = nil
                        }
                )
            }
            .frame(width: side, height: side)
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear { if coords.count != 2 { coords = [xMin, yMin] } }

        // -------------------- ACCESSIBILITY ADDITIONS --------------------
        .focusable(true)                               // keyboard focus
        .onMoveCommand { dir in                        // arrow-key adjustments
            let stepX = xSpan / 20
            let stepY = ySpan / 20
            switch dir {
            case .left:  coords[0] = clamp((coords[safe:0] ?? xMin) - stepX, xMin, xMax)
            case .right: coords[0] = clamp((coords[safe:0] ?? xMin) + stepX, xMin, xMax)
            case .up:    coords[1] = clamp((coords[safe:1] ?? yMin) + stepY, yMin, yMax)
            case .down:  coords[1] = clamp((coords[safe:1] ?? yMin) - stepY, yMin, yMax)
            default: break
            }
        }
        .accessibilityRepresentation {                 // VoiceOver / Switch Control
            VStack {
                Slider(value: Binding(
                           get: { Double(coords[safe:0] ?? xMin) },
                           set: { coords[0] = CGFloat($0) }),
                       in: xMin...xMax) { Text("X axis") }
                    .accessibilityValue(Text("\(Int(coords[safe:0] ?? xMin))"))
                
                Slider(value: Binding(
                           get: { Double(coords[safe:1] ?? yMin) },
                           set: { coords[1] = CGFloat($0) }),
                       in: yMin...yMax) { Text("Y axis") }
                    .accessibilityValue(Text("\(Int(coords[safe:1] ?? yMin))"))
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel("2-D picker")
        }
        // ----------------------------------------------------------------
    }
}
