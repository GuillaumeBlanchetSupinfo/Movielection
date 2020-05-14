//
//  MovielectionUITests.swift
//  MovielectionUITests
//
//  Created by DotVision DotVision on 14/05/2020.
//  Copyright © 2020 Guillaume Blanchet. All rights reserved.
//

import XCTest

class MovielectionUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLaunch() {
        let app = XCUIApplication()
        app.launch()
    }

    func testScrollDownMain() {
        let app = XCUIApplication()
        app.launch()
        XCUIApplication().collectionViews.children(matching: .cell).element(boundBy: 3).children(matching: .other).element.swipeUp()
    }

    func testReloadMain() {
        let app = XCUIApplication()
        app.launch()
        let element = XCUIApplication().collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
        element.swipeDown()
        element.swipeDown()
    }

    func testLoadNewPageMain() {
        let app = XCUIApplication()
        app.launch()
        let collectionViewsQuery = XCUIApplication().collectionViews
        let element = collectionViewsQuery.children(matching: .cell).element(boundBy: 5).children(matching: .other).element
        element.swipeUp()
        element.children(matching: .other).element.swipeUp()
        element.swipeUp()
        element.children(matching: .other).element.swipeUp()
        element.swipeUp()
        element.children(matching: .other).element.swipeUp()
        element.swipeUp()
        element.children(matching: .other).element.swipeUp()
        element.swipeUp()
        element.children(matching: .other).element.swipeUp()
        element.swipeUp()
        element.children(matching: .other).element.swipeUp()
        element.swipeUp()
    }

    func testGoToDetailFormMain() {
        let app = XCUIApplication()
        app.launch()
        XCUIApplication().collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.tap()
    }

    func testGoToSelectedFormMain() {
        let app = XCUIApplication()
        app.launch()
        app.navigationBars["Movielection.Films"].children(matching: .button).matching(identifier: "Item").element(boundBy: 1).tap()
        app.navigationBars["Movielection.Election"].buttons["Back"].tap()
        
    }

    func testGoToDetailFormMainThenAdd() {
        let app = XCUIApplication()
        app.launch()
        app.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.tap()
        app.scrollViews.otherElements.buttons["plus"].tap()
    }

    func testGoToDetailFormMainThenRemove() {
        let app = XCUIApplication()
        app.launch()
        app.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.tap()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["plus"].tap()
        elementsQuery.buttons["trash.fill"].tap()
    }

    func testGoToDetailFormMainThenPlay() {
        let app = XCUIApplication()
        app.launch()
        app.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.tap()
                app.scrollViews.otherElements.buttons["play.fill"].tap()
//        app.navigationBars["Movielection.Film"].buttons["Back"].tap()
        
    }

    func testGoToDetailFormMainThenBack() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        app.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.tap()
        app.navigationBars["Movielection.Film"].buttons["Back"].tap()
    }

    func testGoTo3DetailFormMainAddItThenBackThenGoToSelectedThenRandom() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.tap()
        
        let plusButton = app.scrollViews.otherElements.buttons["plus"]
        plusButton.tap()
        
        let backButton = app.navigationBars["Movielection.Film"].buttons["Back"]
        backButton.tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.tap()
        plusButton.tap()
        backButton.tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 2).children(matching: .other).element.children(matching: .other).element.tap()
        plusButton.tap()
        backButton.tap()
        app.navigationBars["Movielection.Films"].children(matching: .button).matching(identifier: "Item").element(boundBy: 1).tap()
        app.buttons["Select a movie"].tap()
        app.alerts.scrollViews.otherElements.buttons["OK"].tap()
    }
    
    func testGoToSelectedFormMainThenThenQRMaker() {
        let app = XCUIApplication()
        app.launch()
        app.navigationBars["Movielection.Films"].children(matching: .button).matching(identifier: "Item").element(boundBy: 1).tap()
        app.navigationBars["Movielection.Election"].buttons["qrcode"].tap()
        app.sheets.scrollViews.otherElements.buttons["Crée un QR Code de vos films"].tap()
        app.alerts["Oups"].scrollViews.otherElements.buttons["OK"].tap()
    }
    
    func testGoTo3DetailFormMainAddItThenBackThenGoToSelectedThenQRMaker() {
        let app = XCUIApplication()
        app.launch()
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.tap()
        
        let plusButton = app.scrollViews.otherElements.buttons["plus"]
        plusButton.tap()
        
        let backButton = app.navigationBars["Movielection.Film"].buttons["Back"]
        backButton.tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.tap()
        plusButton.tap()
        backButton.tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 2).children(matching: .other).element.children(matching: .other).element.tap()
        plusButton.tap()
        backButton.tap()
        app.navigationBars["Movielection.Films"].children(matching: .button).matching(identifier: "Item").element(boundBy: 1).tap()
        app.navigationBars["Movielection.Election"].buttons["qrcode"].tap()
        app.sheets.scrollViews.otherElements.buttons["Crée un QR Code de vos films"].tap()
        app.alerts.scrollViews.otherElements.buttons["OK"].tap()
    }

    func testGoToDetailFormMainThenWatchDetails() {
        let app = XCUIApplication()
        app.launch()
        app.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.tap()
        
        let scrollViewsQuery = app.scrollViews
        let element = scrollViewsQuery.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element
        element.swipeUp()
        
        let collectionViewsQuery = scrollViewsQuery.otherElements.collectionViews
        collectionViewsQuery.children(matching: .cell).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.swipeLeft()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.swipeRight()
        element.swipeDown()
        app.navigationBars["Movielection.Film"].buttons["Back"].tap()
        
    }

    func testSearch() {
        let app = XCUIApplication()
        app.launch()
        
        
        let movielectionFilmsNavigationBar = XCUIApplication().navigationBars["Movielection.Films"]
        movielectionFilmsNavigationBar.children(matching: .button).matching(identifier: "Item").element(boundBy: 0).tap()
        movielectionFilmsNavigationBar.buttons["arrow.uturn.left"].tap()
        movielectionFilmsNavigationBar.buttons["magnifyingglass"].tap()
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
