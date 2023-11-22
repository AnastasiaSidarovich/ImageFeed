import Foundation

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func applyConstraints()
    func addSubViews()
    func showAlert()
}
