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
}
