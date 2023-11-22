@testable import ImageFeed
import XCTest
import SwiftKeychainWrapper

final class ProfileViewTests: XCTestCase {
    func testProfileViewControllerCallsViewDidLoad() {
        //Given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.profileView = viewController
        
        //When
        _ = viewController.view
        
        //Then
        XCTAssertFalse(presenter.viewDidLoadCalled)
    }
    
    func testProfilePresenterCallsExitProfile() {
        //Given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.profileView = viewController
        
        // When
        presenter.exitProfile()
        
        //Then
        XCTAssertTrue(presenter.profileExited)
    }
    
    func testTokenValueAfterExit() {
        //Given
        let presenter = ProfilePresenter()
        let testTokenValue: String? = nil
        
        //When
        presenter.exitProfile()
        
        //Then
        XCTAssertEqual(KeychainWrapper.standard.string(forKey: "Auth token"), testTokenValue)
    }
}
