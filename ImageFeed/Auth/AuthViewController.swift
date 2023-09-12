import UIKit

final class AuthViewController: UIViewController {
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private let showWebViewSegueIdentifier = "showWebView"
    
    private let logo: UIImageView = {
        let logoImage = UIImage(named: "auth_screen_logo")
        let logo = UIImageView(image: logoImage)
        logo.translatesAutoresizingMaskIntoConstraints = false
        
        return logo
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(Self.didTapLoginButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .ypWhite
        button.layer.cornerRadius = 16
        
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.tintColor = .ypBlack
        
        return button
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
    
    // MARK: - Private Methods
    
    @objc
        private func didTapLoginButton() {
            performSegue(withIdentifier: showWebViewSegueIdentifier, sender: nil)
        }
    
    private func addSubViews() {
        view.addSubview(logo)
        view.addSubview(loginButton)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            logo.heightAnchor.constraint(equalToConstant: 60),
            logo.widthAnchor.constraint(equalToConstant: 60),
            logo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90)
        ])
    }
}

extension AuthViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController
            else {
                assertionFailure("Failed to prepare for \(showWebViewSegueIdentifier)")
                return
            }
            webViewViewController.modalPresentationCapturesStatusBarAppearance = true
            webViewViewController.delegate = self
            webViewViewController.modalPresentationStyle = .overFullScreen
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

    //MARK: - WebViewViewControllerDelegate

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

