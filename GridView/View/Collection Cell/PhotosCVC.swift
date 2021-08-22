

import UIKit

class PhotosCVC: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var imageViewPhoto: UIImageView!

    // MARK: - Properties
    var photoObject: PhotosM? {
        didSet {
            imageViewPhoto.setImage(path: photoObject?.url ?? "", placeholder: .photo)
        }
    }

    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
