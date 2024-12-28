import SwiftUI

/// The custom shape that replaces the old top rectangle.
struct FolderHat: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        
        path.move(to: CGPoint(x: 0.00108*width, y: 0.3113*height))
        path.addCurve(to: CGPoint(x: 0.07537*width, y: 0.00695*height),
                      control1: CGPoint(x: 0.00108*width, y: 0.14321*height),
                      control2: CGPoint(x: 0.03433*width, y: 0.00695*height))
        path.addCurve(to: CGPoint(x: 0.28876*width, y: 0.00695*height),
                      control1: CGPoint(x: 0.13812*width, y: 0.00695*height),
                      control2: CGPoint(x: 0.22732*width, y: 0.00695*height))
        path.addCurve(to: CGPoint(x: 0.44269*width, y: 0.32869*height),
                      control1: CGPoint(x: 0.35331*width, y: 0.00695*height),
                      control2: CGPoint(x: 0.37814*width, y: 0.32869*height))
        path.addCurve(to: CGPoint(x: 0.92471*width, y: 0.32869*height),
                      control1: CGPoint(x: 0.57462*width, y: 0.32869*height),
                      control2: CGPoint(x: 0.8063*width, y: 0.32869*height))
        path.addCurve(to: CGPoint(x: 0.99895*width, y: 0.63303*height),
                      control1: CGPoint(x: 0.96575*width, y: 0.32869*height),
                      control2: CGPoint(x: 0.99895*width, y: 0.46495*height))
        path.addLine(to: CGPoint(x: 0.99895*width, y: 0.99825*height))
        path.addLine(to: CGPoint(x: 0.00108*width, y: 0.99825*height))
        path.addLine(to: CGPoint(x: 0.00108*width, y: 0.3113*height))
        path.closeSubpath()
        return path
    }
}
