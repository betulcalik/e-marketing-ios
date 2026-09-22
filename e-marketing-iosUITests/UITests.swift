//
//  UITests.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 23.09.2026.
//

import XCTest

final class e_marketing_iosUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        logoutIfAuthenticated()
    }

    // MARK: - Flow
    func test_login_home_productsFlow() throws {
        login(username: "emilys", password: "emilyspass")

        // Home -> all categories
        let seeAll = app.buttons["home.categories.seeAll"]
        XCTAssertTrue(seeAll.waitForExistence(timeout: 10))
        seeAll.tap()

        // Categories -> first category
        let firstCategory = app.buttons
            .matching(NSPredicate(format: "identifier BEGINSWITH %@", "categories.item."))
            .firstMatch
        XCTAssertTrue(firstCategory.waitForExistence(timeout: 10))
        firstCategory.tap()

        // Product list renders and scrolls
        let firstProduct = app.buttons
            .matching(NSPredicate(format: "identifier BEGINSWITH %@", "product.addToCart."))
            .firstMatch
        XCTAssertTrue(firstProduct.waitForExistence(timeout: 10))

        app.swipeUp()
        app.swipeUp()
    }
}

// MARK: - Helpers
private extension e_marketing_iosUITests {

    func login(username: String, password: String) {
        let usernameField = app.textFields["login.usernameField"]
        XCTAssertTrue(usernameField.waitForExistence(timeout: 10))
        usernameField.tap()
        usernameField.typeText(username + "\n")

        app.secureTextFields["login.passwordField"].typeText(password + "\n")
    }

    /// Keychain survives reinstalls on the simulator
    func logoutIfAuthenticated() {
        guard !app.textFields["login.usernameField"].waitForExistence(timeout: 2) else { return }
        app.tabBars.buttons.element(boundBy: 1).tap() // Tap Profile page

        let logout = app.buttons["profile.logout"]
        XCTAssertTrue(logout.waitForExistence(timeout: 10))
        logout.tap()

        XCTAssertTrue(app.textFields["login.usernameField"].waitForExistence(timeout: 10))
    }
}
