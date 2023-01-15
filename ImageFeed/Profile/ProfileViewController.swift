import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private var profileService = ProfileService.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    
    
    private var profileImage = UIImageView(image: UIImage(named: "Avatar")!)
    private var profileNameLabel = UILabel()
    private var loginLabel = UILabel()
    private var descriptionLabel = UILabel()
    private let logoutButton = UIButton.systemButton(with: UIImage(named: "logout_button")!,
                                                     target: ProfileViewController.self,
                                                     action: nil)
    let vStackView = UIStackView()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        setProfileContent()
        
        updateProfileDetails(profile: profileService.profile)
        
    }

    
    // MARK: - Private methods
    private func createProfileImage() {
        createViewOnVC(newView: profileImage)
    }
    
    private func createProfileNameLabel() {
        profileNameLabel.text = "name"
        profileNameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        profileNameLabel.textColor = .white
        createViewOnVC(newView: profileNameLabel)
    }
    
    private func createLoginLabel() {
        loginLabel.text = "login"
        loginLabel.font = UIFont(name: "System", size: 13)
        loginLabel.textColor = .ypGray
        createViewOnVC(newView: loginLabel)
    }
    
    private func createDescriptionLabel() {
        descriptionLabel.text = "bio"
        descriptionLabel.font = UIFont(name: "System", size: 13)
        descriptionLabel.textColor = .white
        createViewOnVC(newView: descriptionLabel)
    }
    
    private func createLogoutButton() {
        createViewOnVC(newView: logoutButton)
    }
    
    private func createVStackView() {
        vStackView.distribution = .equalSpacing
        vStackView.spacing = 8
        vStackView.axis = .vertical
        vStackView.addArrangedSubview(profileNameLabel)
        vStackView.addArrangedSubview(loginLabel)
        vStackView.addArrangedSubview(descriptionLabel)
        createViewOnVC(newView: vStackView)
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 76),
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            
            vStackView.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            vStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            profileNameLabel.topAnchor.constraint(equalTo: vStackView.topAnchor),
            profileNameLabel.leadingAnchor.constraint(equalTo: vStackView.leadingAnchor),
            
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    
    private func setProfileContent() {
        assert(Thread.isMainThread)
        view.backgroundColor = .ypBlack
        createProfileImage()
        createProfileNameLabel()
        createLoginLabel()
        createDescriptionLabel()
        createLogoutButton()
        createVStackView()
        activateConstraints()
    }
    
    private func createViewOnVC(newView: UIView) {
        newView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newView)
    }
}



// MARK: - Update profile

extension ProfileViewController {
    
    private func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else { return }
        profileNameLabel.text = profile.name
        loginLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
}
