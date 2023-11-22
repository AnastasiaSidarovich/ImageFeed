import ImageFeed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var profileView: ImageFeed.ProfileViewControllerProtocol?
    var profileExited: Bool = false
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad(){
        viewDidLoadCalled = true
    }
    
    func exitProfile() {
        profileExited = true
    }
}
