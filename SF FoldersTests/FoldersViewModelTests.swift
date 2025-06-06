//
// SF Folders
// FoldersViewModelTests.swift
//
// Created on 5/6/25
//
// Copyright ©2025 DoorHinge Apps.
//


import XCTest
@testable import SF_Folders

final class FoldersViewModelTests: XCTestCase {
    func testDefaultValues() {
        let vm = FoldersViewModel()
        XCTAssertEqual(vm.symbolName, "star.fill")
        XCTAssertEqual(vm.iconScale, 1.0)
        XCTAssertEqual(vm.imageType, .sfsymbol)
    }

    func testPropertyMutation() {
        let vm = FoldersViewModel()
        vm.symbolName = "heart.fill"
        XCTAssertEqual(vm.symbolName, "heart.fill")
    }
    
    func testDefaultBooleanValues() {
        let vm = FoldersViewModel()
        XCTAssertFalse(vm.showIconPicker)
        XCTAssertFalse(vm.isTargetedDrop)
        XCTAssertFalse(vm.breatheAnimation)
        XCTAssertFalse(vm.rotateAnimation)
    }

    func testImageTypeUpdates() {
        let vm = FoldersViewModel()
        XCTAssertEqual(vm.imageType, .sfsymbol)
        vm.imageType = .png
        XCTAssertEqual(vm.imageType, .png)
        vm.imageType = .none
        XCTAssertEqual(vm.imageType, .none)
    }

    func testScaleAndOffsetUpdates() {
        let vm = FoldersViewModel()
        vm.iconScale = 2.5
        vm.iconOffset = 12
        vm.iconOffsetX = -3
        XCTAssertEqual(vm.iconScale, 2.5, accuracy: 0.001)
        XCTAssertEqual(vm.iconOffset, 12)
        XCTAssertEqual(vm.iconOffsetX, -3)
    }

    func testPresetsCount() {
        let vm = FoldersViewModel()
        XCTAssertEqual(vm.presets.count, 8)
    }
}
