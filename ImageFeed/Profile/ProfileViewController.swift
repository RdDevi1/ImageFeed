
import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
      //  super.viewDidLoad
        view.backgroundColor = .ypBlack
        
        let avatar = UIImage(named: "Avatar")!
        let profileImage = UIImageView(image: avatar)
        createViewOnVC(newView: profileImage)
        
        let profileNameLabel = UILabel()
        profileNameLabel.text = "Екатерина Новикова"
        profileNameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        createViewOnVC(newView: profileNameLabel)
        
        let loginLabel = UILabel()
        loginLabel.text = "@ekaterina_nov"
        loginLabel.font = UIFont(name: "System", size: 13)
        loginLabel.textColor = .ypGray
        createViewOnVC(newView: loginLabel)
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hallo, world!"
        descriptionLabel.font = UIFont(name: "System", size: 13)
        createViewOnVC(newView: descriptionLabel)

        
        let logoutImage = UIImage(named: "logoutButton")!
        let logoutButton = UIButton.systemButton(with: logoutImage,
                                                 target: self,
                                                 action: nil)
        createViewOnVC(newView: logoutButton)
        
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 76),
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            
            profileNameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            profileNameLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            
            loginLabel.topAnchor.constraint(equalTo: profileNameLabel.bottomAnchor, constant: 8),
            loginLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
            
        ])
        
        
    }
    
    func createViewOnVC(newView: UIView) {
        newView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newView)
    }
}
