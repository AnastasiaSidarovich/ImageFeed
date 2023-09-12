import UIKit

final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
                
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        
        imagesListViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_editorial_active"), selectedImage: nil)
        imagesListViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -9, right: 0)
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_profile_active"), selectedImage: nil)
        profileViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -9, right: 0)
               
        self.viewControllers = [imagesListViewController, profileViewController]
        }
}
