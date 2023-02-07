import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Properties
    weak var delegate: ImagesListCellDelegate?
    static let reuseIdentifier = "ImagesListCell"
    private let cellImageGradient = CAGradientLayer()
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    func configCell(for cell: ImagesListCell, from photos: [Photo], with indexPath: IndexPath) {
        let imageUrl = photos[indexPath.row].thumbImageURL
        let url = URL(string: imageUrl)
        
        likeButton.isHidden = true
        dateLabel.isHidden = true
        showGradient(for: cell)
        
        // cell.frame.size.height = cell.cellImage.frame.height
        
        //cell.cellImage.kf.indicatorType = .none
        cell.cellImage.kf.setImage(with: url,
                                   placeholder: UIImage(named: "placeholderImageList")) { _ in
            self.removeGradient(gradient: self.cellImageGradient)
            self.likeButton.isHidden = false
            self.dateLabel.isHidden = false
        }
        
        if let createdAt = photos[indexPath.row].createdAt {
            dateLabel.text = createdAt.dateTimeString
        } else {
            dateLabel.text = ""
        }
        
        setIsLiked(isLiked: photos[indexPath.row].isLiked)
    }
    
    
    func setIsLiked(isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "like_on") : UIImage(named: "like_off")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    private func showGradient(for cell: ImagesListCell) {
        //guard let image = UIImage(named: "placeholderImageList") else { return }
        cellImageGradient.frame.size.height = cell.cellImage.frame.height
        cellImageGradient.frame.size.width = cell.frame.width
        cell.addGradient(gradient: cellImageGradient, cornerRadius: 16)
        cell.cellImage.layer.addSublayer(cellImageGradient)
    }
}