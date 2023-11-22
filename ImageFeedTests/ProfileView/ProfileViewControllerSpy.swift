import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ImageFeed.ProfilePresenterProtocol?
    
    func applyConstraints() { }
    
    func addSubViews() { }
    
    func showAlert() { }
}
