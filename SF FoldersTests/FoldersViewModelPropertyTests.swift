//
// SF Folders
// FoldersViewModelPropertyTests.swift
//
// Created on 5/6/25
//
// Copyright ©2025 DoorHinge Apps.
//


import XCTest
@testable import SF_Folders
import AppKit

final class FoldersViewModelPropertyTests: XCTestCase {
    func testSwitchImageTypes() {
        let vm = FoldersViewModel()
        XCTAssertEqual(vm.imageType, .sfsymbol)
        vm.imageType = .png
        XCTAssertEqual(vm.imageType, .png)
        vm.imageType = .none
        XCTAssertEqual(vm.imageType, .none)
    }

    func testIconAndSymbolAdjustments() {
        let vm = FoldersViewModel()
        vm.symbolName = "heart.fill"
        XCTAssertEqual(vm.symbolName, "heart.fill")
        vm.iconScale = 2.0
        XCTAssertEqual(vm.iconScale, 2.0, accuracy: 0.001)
        vm.symbolOpacity = 0.75
        XCTAssertEqual(vm.symbolOpacity, 0.75, accuracy: 0.001)
        vm.iconOffset = 10
        vm.iconOffsetX = -5
        XCTAssertEqual(vm.iconOffset, 10)
        XCTAssertEqual(vm.iconOffsetX, -5)
    }

    func testSelectingImage() {
        let vm = FoldersViewModel()
        let img = NSImage(size: NSSize(width: 1, height: 1))
        vm.selectedImage = img
        XCTAssertNotNil(vm.selectedImage)
        vm.selectedImage = nil
        XCTAssertNil(vm.selectedImage)
    }
}
