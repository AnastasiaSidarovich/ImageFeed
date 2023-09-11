import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let showAuthenticationScreenSegueIdentifier = "showAuthenticationScreen"
    
    private let oauth2Service = OAuth2Service()
    private let tokenStorege = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var alertPresenter: AlertPresenterProtocol?
    
    private let logo: UIImageView = {
        let logoImage = UIImage(named: "splash_screen_logo")
        let logo = UIImageView(image: logoImage)
        logo.translatesAutoresizingMaskIntoConstraints = false
        
        return logo
    }()
    
    // MARK: - Override Methods
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        addSubViews()
        applyConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        alertPresenter = AlertPresenter(viewController: self)
        
        if let token = tokenStorege.token {
            self.fetchProfile(token: token)
        } else {
            switchToAuthViewController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: - Private Methods
    
    private func switchToTabBarViewController() {
        guard let window = UIApplication.shared.windows.first else { assertionFailure("Invalid Configuration")
            return
        }
        let tabBarViewController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarViewController
    }
    
    private func switchToAuthViewController() {
        guard let authViewController = UIStoryboard(
            name: "Main",
            bundle: .main
        ).instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
            assertionFailure("Не удалось создать AuthViewController!")
            return
        }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        self.present(authViewController, animated: true)
    }
    
    private func showAlertNetworkError() {
        let alertModel = AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            buttonText: "ОК",
            completion: nil
        )
        alertPresenter?.presentAlert(alertModel)
    }
    
    private func addSubViews() {
        view.addSubview(logo)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            logo.heightAnchor.constraint(equalToConstant: 78),
            logo.widthAnchor.constraint(equalToConstant: 75),
            logo.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            logo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
}

//MARK: - AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }

    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let token):
                UIBlockingProgressHUD.dismiss()
                self.fetchProfile(token: token)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                showAlertNetworkError()
                break
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                UIBlockingProgressHUD.dismiss()
                profileImageService.fetchProfileImageURL(token: token, username: data.username) { _ in }
                self.switchToTabBarViewController()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                showAlertNetworkError()
                break
            }
        }
    }
}
