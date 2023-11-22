import Foundation

public protocol ProfilePresenterProtocol {
    var profileView: ProfileViewControllerProtocol? { get set }
    func exitProfile()
}
