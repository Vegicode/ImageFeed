
import UIKit
import Kingfisher

final class ProfileViewController: UIViewController{
    private var profileImage: UIImageView?
    private var profileImageServiceObserver: NSObjectProtocol?
    private var label: UILabel?
    private var label2: UILabel?
    private var label3: UILabel?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createProfileImageView()
        createLabels()
        createButton()
        guard let profile = ProfileService.shared.profile else {return}
        updateProfileDetails(profile:profile )
        profileImageServiceObserver = NotificationCenter.default    // 2
            .addObserver(
                forName: ProfileImageService.didChangeNotification, // 3
                object: nil,                                        // 4
                queue: .main                                        // 5
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()                                 // 6
            }
        updateAvatar()
        

    }
    private func updateAvatar() {                                   // 8
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else {
            return }
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        self.profileImage?.kf.indicatorType = .activity
        self.profileImage?.kf.setImage(with: url,
                                       placeholder: UIImage(named: "tab_profile_active"),
                                       options: [.processor(processor),
                                                 .cacheSerializer(FormatIndicatedCacheSerializer.png),
                                        .transition(.fade(0.2))
                                       ]
        ){
            result in
            switch result{
            case .success(let value):
                print("Image: \(value.image)")
                print("Cache type: \(value.cacheType)")
                print("Sourse: \(value.source)")
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
    
    @objc
            private func didTapLogoutButton() {
                
            }
    
    
}

extension ProfileViewController{
    func createProfileImageView() {
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
    }
    
    func createLabels(){
        
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
        
        label.leadingAnchor.constraint(equalTo: profileImage!.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: profileImage!.bottomAnchor, constant: 10).isActive = true
        self.label = label
        
        label2.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
        
        label2.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        
        label3.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 10).isActive = true
        
        label3.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        
    }
    
    func createButton() {
        let button = UIButton()
        button.setImage(UIImage(named: "log out"), for: .normal)
        button.tintColor = UIColor(named: "ColorRed")
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func updateProfileDetails(profile: Profile){
        self.label3?.text = profile.bio
        self.label?.text = profile.name
        self.label2?.text = profile.loginName
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
