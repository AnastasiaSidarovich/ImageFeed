import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
        
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 5))
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("<Ваш логин>")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("<Ваш пароль>")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        sleep(2)
        
        let webViewsQuery = app.webViews
        webViewsQuery.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
        
    func testFeed() throws {
        let tablesQuery = app.tables
            
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
            
        sleep(2)
            
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        if cellToLike.buttons["LikeButtonOff"].exists {
            cellToLike.buttons["LikeButtonOff"].tap()
            cellToLike.buttons["LikeButtonOn"].tap()
        } else
        if cellToLike.buttons["LikeButtonOn"].exists {
            cellToLike.buttons["LikeButtonOn"].tap()
            cellToLike.buttons["LikeButtonOff"].tap()
        }
            
        sleep(2)
            
        cellToLike.tap()
            
        sleep(2)
            
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
            
        let navigationBackButton = app.buttons["NavigationBackButton"]
        navigationBackButton.tap()
    }
        
    func testProfile() throws {
        sleep(3)
        
        app.tabBars.buttons.element(boundBy: 1).tap()
           
        XCTAssertTrue(app.staticTexts["Name Lastname"].exists)
        XCTAssertTrue(app.staticTexts["@username"].exists)
            
        app.buttons["LogoutButton"].tap()
            
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
    }
}

