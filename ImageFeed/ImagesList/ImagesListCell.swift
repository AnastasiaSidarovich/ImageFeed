import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    let gradient = CAGradientLayer()
    let black = UIColor(named: "ypBlack")
   
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var cellImage: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = cellImage.bounds
    }
}

extension ImagesListCell {
    func addGradient() {
        
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.8).cgColor]
        gradient.locations = [0.7, 1.0]
        gradient.frame = cellImage.bounds
                
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
                
        cellImage.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
                
        cellImage.layer.addSublayer(gradient)
    }
}
