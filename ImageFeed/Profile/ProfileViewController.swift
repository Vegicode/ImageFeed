
import UIKit

final class ProfileViewController: UIViewController{
    
    private var label: UILabel?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileImage = UIImage(named: "Image")
        let imageView = UIImageView(image: profileImage)
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
        
        ])
        
        let label = UILabel()
        label.text = "Name"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        self.label = label
        
        
        
        let button = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapLogoutButton)
        )
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
    @objc
            private func didTapLogoutButton() {
                label?.removeFromSuperview()
                      
                label = nil
            }
    
}


//final class ProfileViewController: UIViewController {
//    @IBOutlet private var avatarImageView: UIImageView!
//    @IBOutlet private var nameLabel: UILabel!
//    @IBOutlet private var loginNameLabel: UILabel!
//    @IBOutlet private var descriptionLabel: UILabel!
//
//    @IBOutlet private var logoutButton: UIButton!
//
//    @IBAction private func didTapLogoutButton() {
//        
//    }
//}
