
import Foundation
import UIKit
import MBProgressHUD

extension UIViewController {
    func alertSimpleShow(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in

        }))

        self.present(alert, animated: true, completion: nil)
    }

    func showLoader() {
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading"
    }

    func hideLoder() {
        MBProgressHUD.hide(for: view, animated: true)
    }
}
