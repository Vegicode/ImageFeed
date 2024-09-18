import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"

    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    func setIsLiked(isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "Active") : UIImage(named: "No Active")
       likeButton.setImage(likeImage, for: .normal)
    }
    @IBAction func likeButtonClicked(_ sender: Any) {
        
    }
}
