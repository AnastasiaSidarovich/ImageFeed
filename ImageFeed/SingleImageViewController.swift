import UIKit

final class SingleImageViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var backButton: UIButton!
    
    var fullImageURL: URL! {
        didSet {
            guard isViewLoaded else { return }
            setImage()
        }
    }
    
    private var alertPresenter: AlertPresenterProtocol?
    
    // MARK: - Override Methods
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.accessibilityIdentifier = "NavigationBackButton"
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        alertPresenter = AlertPresenter(viewController: self)
        setImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        centerImageAfterZooming()
    }
    
    // MARK: - Private Methods
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let hScale = visibleRectSize.width / image.size.width
        let vScale = visibleRectSize.height / image.size.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func centerImageAfterZooming() {
        let halfWidth = (scrollView.bounds.size.width - imageView.frame.size.width) / 2
        let halfHight = (scrollView.bounds.size.height - imageView.frame.size.height) / 2
        scrollView.contentInset = .init(top: halfHight, left: halfWidth, bottom: 0, right: 0)
    }
    
    private func setImage() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: fullImageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            switch result {
                case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
                case .failure:
                self.showError()
                }
            }
    }

    private func showError() {
        let alertModel = AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            buttonText: "ОК",
            completion: { [weak self] in
                guard let self = self else { return }
                UIBlockingProgressHUD.show()
                setImage()
            },
            secondButtonText: "Нет",
            secondCompletion: { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            })
        alertPresenter?.presentAlert(alertModel)
    }
    // MARK: - IBAction
    
    @IBAction private func didTapShareButton() {
        guard let image = imageView.image else {
           return
        }
        let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(share, animated: true, completion: nil)
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.centerImageAfterZooming()
        }
    }
}
