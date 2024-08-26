
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
        let label2 = UILabel()
        let label3 = UILabel()
        label.text = "Екатерина Новикова"
        label2.text = "@ekaterina_nov"
        label3.text = "Hello, world!"
        
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 23)
        
        label2.textColor = UIColor(named: "subTColor")
        label3.textColor = .white
        
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        label2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label2)
        
        label3.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label3)
        
        label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        self.label = label
        
        label2.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
        
        label2.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        
        label3.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 10).isActive = true
        
        label3.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        
        
        
        
        let button = UIButton.systemButton(
            with: UIImage(named: "Exit")!,
            target: self,
            action: #selector(Self.didTapLogoutButton)
        )
        button.tintColor = UIColor(named: "ColorRed")
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
    @objc
            private func didTapLogoutButton() {
                
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
