

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func setImage(path:String?, placeholder:PlaceholderImage) {
        self.kf.indicatorType = .activity
        self.kf.setImage(with: URL(string: path ?? ""), placeholder: UIImage(named: placeholder.rawValue))
    }
}
