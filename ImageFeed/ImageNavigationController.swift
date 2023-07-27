import UIKit

final class ImageNavigationController: UINavigationController {

    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}
