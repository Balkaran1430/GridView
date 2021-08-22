

import UIKit
import ObjectMapper

class PhotosVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var collectionViewPhotos: UICollectionView!
    @IBOutlet weak var viewPhotoFull: UIView!
    @IBOutlet weak var labelPhotoCount: UILabel!
    @IBOutlet weak var scrollViewPhotoFull: UIScrollView!
    
    // MARK: - Properties
    var arrayPhotos = [PhotosM]()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        getPhotosApi()
    }

    @IBAction func viewOutsideAction(_ sender: UIControl) {
        viewPhotoFull.isHidden = true
    }
}

// MARK: - Custom Methods
extension PhotosVC {
    func setupCollectionView() {
        collectionViewPhotos.register(UINib(nibName: "PhotosCVC", bundle: nil), forCellWithReuseIdentifier: "PhotosCVC")
    }

    func addScrollView() {
        for i in 0..<arrayPhotos.count {
            let gallerySingle = arrayPhotos[i]
            let x = self.view.frame.size.width * CGFloat(i)
            let imageViewFull = EFImageViewZoom(frame: CGRect(x: x + 10, y: 0, width: self.view.frame.size.width - 20, height: scrollViewPhotoFull.frame.size.height))
            imageViewFull.awakeFromNib()
            imageViewFull._minimumZoomScale = 1.0
            imageViewFull._maximumZoomScale = 10.0
            imageViewFull.imageView.layer.cornerRadius = 10
            imageViewFull.backgroundColor = .clear
            imageViewFull.contentModeImageView = .scaleAspectFit
            imageViewFull.isUserInteractionEnabled = true
            imageViewFull.clipsToBounds = true
            imageViewFull._delegate = self
            imageViewFull.imageView.setImage(path: gallerySingle.url ?? "", placeholder: .photo)
            scrollViewPhotoFull.delegate = self
            scrollViewPhotoFull.addSubview(imageViewFull)
            labelPhotoCount.text = "1 " + "of" + " \(arrayPhotos.count)"
        }

    }
}

// MARK: - Action
extension PhotosVC {
    @IBAction func buttonActionCross(_ sender: UIButton) {
        viewPhotoFull.isHidden = true
    }


}

// MARK: - Collection View Delegates and Datasoureces
extension PhotosVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayPhotos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCVC", for: indexPath) as? PhotosCVC
        cell?.photoObject = arrayPhotos[indexPath.row]
        return cell ??  UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3, height: collectionView.frame.size.width/3)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for imageView in scrollViewPhotoFull.subviews {
            if let imgV = imageView as? EFImageViewZoom {
                imgV.setZoomScale(1.0, animated: false)
            }
        }

        viewPhotoFull.isHidden = false
        labelPhotoCount.text = "\(indexPath.row + 1) " + "of" + " \(arrayPhotos.count)"

        scrollViewPhotoFull.contentOffset.x = CGFloat(indexPath.row) * view.frame.size.width
        scrollViewPhotoFull.contentSize.width = view.frame.size.width * CGFloat(arrayPhotos.count)
    }
}

// MARK: - Zoom out and in Delegates
extension PhotosVC: EFImageViewZoomDelegate {

}

// MARK: - Scroll View Delegates
extension PhotosVC: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        labelPhotoCount.text = "\(Int(pageNumber + 1)) " + "of" + " \(arrayPhotos.count)"

    }
}



// MARK: - Service Implementation
extension PhotosVC {

    func getPhotosApi() {
          showLoader()
        APIManager.shared.requestWithoutHeader(url: get_photos, method: .get) { _ in
            self.hideLoder()
        } success: { response in
            let arrayPhotos = Mapper<PhotosM>().mapArray(JSONObject: response)
            print(#line,arrayPhotos?[0].url ?? "")
            self.arrayPhotos = arrayPhotos ?? []
            self.addScrollView()
            self.collectionViewPhotos.reloadData()

        } failure: { error in
            self.alertSimpleShow(title: "Error", message: error ?? "Something went wrong")
        }

    }
}
