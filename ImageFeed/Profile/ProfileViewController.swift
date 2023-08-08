import UIKit

final class ProfileViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let whiteColor = getColorFromAssets(named: "ypWhite")
        let grayColor = getColorFromAssets(named: "ypGray")
        let blackColor = getColorFromAssets(named: "ypBlack")
        
        view.backgroundColor = blackColor
        
        let profileImageView = addImageView()
        let nameLabel = addLabel(text: "Екатерина Новикова",
                                 textSize: 23,
                                 textStyle: .bold,
                                 textColor: whiteColor)
        let loginNameLabel = addLabel(text: "@ekaterina_nov",
                                      textSize: 13,
                                      textStyle: .regular,
                                      textColor: grayColor)
        let descriptionLabel = addLabel(text: "Hello, world!",
                                        textSize: 13,
                                        textStyle: .regular,
                                        textColor: whiteColor)
        let logoutButton = addButton()
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor),
            logoutButton.leadingAnchor.constraint(greaterThanOrEqualTo: profileImageView.trailingAnchor)
            ])
    }
    
    private func addImageView() -> UIImageView {
        let avatarImage = UIImage(named: "avatar")
        let imageView = UIImageView(image: avatarImage)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        
        return imageView
    }
    
    private func addLabel(text: String, textSize: CGFloat, textStyle: UIFont.Weight, textColor: UIColor) -> UILabel {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        label.text = text
        label.font = UIFont.systemFont(ofSize: textSize, weight: textStyle)
        label.textColor = textColor
        
        label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16).isActive = true
        
        return label
    }
    
    private func addButton() -> UIButton {
        guard let imageButton = UIImage(named: "logout_button") else {
            fatalError("Картинка не найдена!")
        }
        let button = UIButton.systemButton(with: imageButton, target: self, action: #selector(Self.didTapButton))
        button.tintColor = UIColor(named: "ypRed")
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45).isActive = true
        
        return button
    }
    
    @objc
        private func didTapButton() {
            
        }
}

extension ProfileViewController {
    func getColorFromAssets(named name: String) -> UIColor {
        guard let color = UIColor(named: name) else {
            fatalError("Цвет с названием '\(name)' не найден!")
        }
        return color
    }
}
