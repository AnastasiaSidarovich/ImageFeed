import Foundation
import UIKit

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var profileView: ProfileViewControllerProtocol?
    
    private let profileService = ProfileService.shared
    private let tokenStorage = OAuth2TokenStorage.shared
    
    func exitProfile() {
        tokenStorage.token = nil
        profileService.clearProfile()
        WebViewViewController.clean()
        guard let window = UIApplication.shared.windows.first else { assertionFailure("Invalid Configuration")
            return
        }
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
    }
}
