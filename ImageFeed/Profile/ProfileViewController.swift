import UIKit

final class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
     
        view.backgroundColor = .ypBlack
        
        let avatar = UIImage(named: "Avatar")!
        let profileImage = UIImageView(image: avatar)
        createViewOnVC(newView: profileImage)
        
        let profileNameLabel = UILabel()
        profileNameLabel.text = "Екатерина Новикова"
        profileNameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        profileNameLabel.textColor = .white
        createViewOnVC(newView: profileNameLabel)
        
        let loginLabel = UILabel()
        loginLabel.text = "@ekaterina_nov"
        loginLabel.font = UIFont(name: "System", size: 13)
        loginLabel.textColor = .ypGray
        createViewOnVC(newView: loginLabel)
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hallo, world!"
        descriptionLabel.font = UIFont(name: "System", size: 13)
        descriptionLabel.textColor = .white
        createViewOnVC(newView: descriptionLabel)

        
        let logoutImage = UIImage(named: "logoutButton")!
        let logoutButton = UIButton.systemButton(with: logoutImage,
                                                 target: self,
                                                 action: nil)
        createViewOnVC(newView: logoutButton)
        
        let vStackViewWithLabels = UIStackView()
        vStackViewWithLabels.distribution = .equalSpacing
        vStackViewWithLabels.spacing = 8
        vStackViewWithLabels.axis = .vertical
        vStackViewWithLabels.addArrangedSubview(profileNameLabel)
        vStackViewWithLabels.addArrangedSubview(loginLabel)
        vStackViewWithLabels.addArrangedSubview(descriptionLabel)
        createViewOnVC(newView: vStackViewWithLabels)
        
        
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 76),
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            
            vStackViewWithLabels.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            vStackViewWithLabels.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            profileNameLabel.topAnchor.constraint(equalTo: vStackViewWithLabels.topAnchor),
            profileNameLabel.leadingAnchor.constraint(equalTo: vStackViewWithLabels.leadingAnchor),

            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        
    }
    
    func createViewOnVC(newView: UIView) {
        newView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newView)
    }
}
