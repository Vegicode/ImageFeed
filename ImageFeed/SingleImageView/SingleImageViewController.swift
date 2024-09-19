import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage? {
        didSet {
            guard isViewLoaded, let image else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    var imageURL: Photo?

    @IBOutlet private var imageView: UIImageView!

    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        guard let imageURL else { return }
        
        openImage(photo: imageURL)

    }
    private func openImage(photo: Photo) {
        
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: URL(string: photo.largeImageURL)) {[weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else {return}
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                print("[SingleImageViewController]:[setImage]: Error getting single image")
            }
        }
        imageView.frame.size = photo.size
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        guard let image else { return }
        let share = UIActivityViewController(
            activityItems: [image], 
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        if imageView.frame.height <= scrollView.frame.height {
                let shiftHeight = scrollView.frame.height/2.0 - scrollView.contentSize.height/2.0
                scrollView.contentInset.top = shiftHeight
            }
            if imageView.frame.width <= scrollView.frame.width {
                let shiftWidth = scrollView.frame.width/2.0 - scrollView.contentSize.width/2.0
                scrollView.contentInset.left = shiftWidth
            }
    }
}
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
}

