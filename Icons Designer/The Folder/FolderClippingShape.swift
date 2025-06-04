//
// SF Folders
// FolderClippingShape.swift
//
// Created on 28/12/24
//
// Copyright ©2024 DoorHinge Apps.
//


import SwiftUI

struct FolderClippingShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.99809*width, y: 0.91019*height))
        path.addLine(to: CGPoint(x: 0.99809*width, y: 0.18292*height))
        path.addCurve(to: CGPoint(x: 0.92385*width, y: 0.09454*height), control1: CGPoint(x: 0.99809*width, y: 0.13411*height), control2: CGPoint(x: 0.96489*width, y: 0.09454*height))
        path.addLine(to: CGPoint(x: 0.44182*width, y: 0.09454*height))
        path.addCurve(to: CGPoint(x: 0.2879*width, y: 0.0011*height), control1: CGPoint(x: 0.37727*width, y: 0.09454*height), control2: CGPoint(x: 0.35245*width, y: 0.0011*height))
        path.addLine(to: CGPoint(x: 0.0745*width, y: 0.0011*height))
        path.addCurve(to: CGPoint(x: 0.00021*width, y: 0.08949*height), control1: CGPoint(x: 0.03346*width, y: 0.0011*height), control2: CGPoint(x: 0.00021*width, y: 0.04067*height))
        path.addLine(to: CGPoint(x: 0.00021*width, y: 0.1703*height))
        path.addLine(to: CGPoint(x: 0.00021*width, y: 0.91019*height))
        path.addCurve(to: CGPoint(x: 0.07452*width, y: 0.99858*height), control1: CGPoint(x: 0.00021*width, y: 0.95901*height), control2: CGPoint(x: 0.03348*width, y: 0.99858*height))
        path.addLine(to: CGPoint(x: 0.92378*width, y: 0.99858*height))
        path.addCurve(to: CGPoint(x: 0.99809*width, y: 0.91019*height), control1: CGPoint(x: 0.96482*width, y: 0.99858*height), control2: CGPoint(x: 0.99809*width, y: 0.95901*height))
        path.closeSubpath()
        return path
    }
}
