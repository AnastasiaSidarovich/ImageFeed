import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func presentAlert(_ result: AlertModel) {
        let alert = UIAlertController(title: result.title, message: result.message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            result.completion?()
        }
        alert.addAction(action)
        
        if let secondButtonText = result.secondButtonText {
            let secondAction = UIAlertAction(title: result.secondButtonText, style: .default) { _ in
                result.secondCompletion?()
            }
            alert.addAction(secondAction)
        }
        viewController?.present(alert, animated: true, completion: nil)
    }
}
