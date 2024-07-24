
import UIKit

final class ProfileViewController: UIViewController{
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var loginLabel: UILabel!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var descriptionLabel: UILabel!
    
    
    
    
    @IBAction func didTapLogoutButton(_ sender: Any) {
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
