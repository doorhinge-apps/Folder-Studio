//
// Icons Designer
// FolderTop.swift
//
// Created on 27/12/24
//
// Copyright ©2024 DoorHinge Apps.
//

import SwiftUI

/// A custom shape that replaces the old top rectangle.
struct MyIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        
        // The path instructions you provided
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

/// Helper to convert the SwiftUI `MyIcon` shape into a `CGPath` of a given size.
func cgPathForMyIcon(size: CGSize) -> CGPath {
    // Create a SwiftUI Path for the given size
    let swiftUIPath = MyIcon().path(in: CGRect(origin: .zero, size: size))
    
    // Convert it to a CGPath. The transform .identity means no additional transform needed.
    return swiftUIPath.cgPath
}
