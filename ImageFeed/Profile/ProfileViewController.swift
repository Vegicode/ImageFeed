import UIKit
import WebKit
import Kingfisher
import SwiftKeychainWrapper

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateAvatar()
    func logout()
    func showAlert(alert: UIAlertController)
    func addSubviews()
    func addConstrains()
    func configure(_ presenter: ProfilePresenterProtocol)
}


class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
   
    
    var presenter: ProfilePresenterProtocol?

    private var profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?

    var avatarImageView: UIImageView = {
        let avatar = UIImageView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.image = UIImage(named: "Avatar")
        avatar.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatar.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatar.contentMode = .scaleAspectFit
        
        return avatar
    }()
    
    var namelabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Екатерина Новикова"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 23)
        return label
    }()
    
    var loginNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "@ekaterina_nov"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello world!"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    
    @objc let logoutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Exit"), for: .normal)
        button.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "ypBlack")
        
        presenter?.viewDidLoad()
       // addSubviews()
       // addConstrains()
        
        
        
        
        guard let profile = presenter?.getProfile() else {
                    print("No profile data found")
                    return
                }
        updateProfileDetails(profile: profile)
        
        profileImageServiceObserver = NotificationCenter.default
                    .addObserver(
                        forName: ProfileImageService.didChangeNotification,
                        object: nil, queue: .main) { [weak self] _ in
                        guard let self = self else { return }
                        self.updateAvatar()
                    }
               
        updateAvatar()
        
        logoutButton.accessibilityIdentifier = "Exit"
        logoutButton.addTarget(self, action: #selector(getter: logoutButton), for: .touchUpInside)
        
    }
    
    
    func configure(_ presenter: ProfilePresenterProtocol){
               self.presenter = presenter
               self.presenter?.view = self
           }
    
    private func updateProfileDetails(profile: Profile) {
        namelabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    
    func updateAvatar() {
        let url = presenter?.getAvatarUrl()
      
        let procesoor = RoundCornerImageProcessor(cornerRadius: 35, backgroundColor: UIColor(named: "ypBlack"))
        
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(with: url,
                                         placeholder: UIImage(named: "Placeholder"),
                                         options: [.processor(procesoor)]
        )
    }
   
  
    
    func addSubviews() {
        view.addSubview(avatarImageView)
        view.addSubview(namelabel)
        view.addSubview(loginNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(logoutButton)
    }
    
    func addConstrains() {
        avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        namelabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8).isActive = true
        namelabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        loginNameLabel.topAnchor.constraint(equalTo: namelabel.bottomAnchor, constant: 8).isActive = true
        loginNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }
    
    
    
    func logout() {
        cleanCookies()
        KeychainWrapper.standard.removeObject(forKey: "Bearer Token")
        
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
    }
    func cleanCookies(){
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    func showAlert(alert: UIAlertController) {
        present(alert, animated: true)
    }
    
    
    @objc
    private func didTapLogoutButton() {
        presenter?.logout()
        
        
    }
    
   
    
  
}
