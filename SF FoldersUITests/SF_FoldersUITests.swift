//
// SF Folders
// AppLaunchTests.swift
//
// Created on 5/6/25
//
// Copyright ©2025 DoorHinge Apps.
//


import XCTest

final class SF_Symbols_FoldersUITests: XCTestCase {
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.windows.element(boundBy: 0).exists)
    }

    func testSwitchImageTypesAndButtons() throws {
        let app = XCUIApplication()
        app.launch()
        let imageText = app.staticTexts["Image"]
        if imageText.exists {
            imageText.tap()
            XCTAssert(app.buttons["Select"].exists || app.buttons["Change"].exists)
        }
        let symbolText = app.staticTexts["SF Symbol"]
        if symbolText.exists {
            symbolText.tap()
            XCTAssert(app.buttons["star.fill"].exists)
        }
        let noneText = app.staticTexts["None"]
        if noneText.exists {
            noneText.tap()
        }
    }
    
    func testSaveAsImageButtonExists() throws {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.buttons["Save as Image"].waitForExistence(timeout: 2))
    }

    func testPresetsLabelExists() throws {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.staticTexts["Presets"].exists)
    }

    func testSymbolButtonAppearsAfterSwitch() throws {
        let app = XCUIApplication()
        app.launch()
        let symbolText = app.staticTexts["SF Symbol"]
        if symbolText.exists {
            symbolText.tap()
            XCTAssertTrue(app.buttons["star.fill"].exists)
        }
    }
}
