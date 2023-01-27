import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private var profileService = ProfileService.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Avatar")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 35
        return imageView
    }()
    
    private lazy var profileNameLabel: UILabel = {
        let label = UILabel()
        label.text = "name"
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textColor = .white
        return label
    }()
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "login"
        label.font = UIFont(name: "System", size: 13)
        label.textColor = .ypGray
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "bio"
        label.font = UIFont(name: "System", size: 13)
        label.textColor = .white
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage(named: "logout_button")!,
                                           target: ProfileViewController.self,
                                           action: nil)
        return button
    }()
    
    private lazy var vStackView: UIStackView = {
        let vStack = UIStackView()
        vStack.distribution = .equalSpacing
        vStack.spacing = 8
        vStack.axis = .vertical
        vStack.addArrangedSubview(profileNameLabel)
        vStack.addArrangedSubview(loginLabel)
        vStack.addArrangedSubview(descriptionLabel)
        return vStack
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        setProfileViewLayout()
        updateProfileDetails(profile: profileService.profile)
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateAvatar()
        }
        
        updateAvatar()
    }

    
    // MARK: - Private methods
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        
        avatarImageView.kf.setImage(with: url,
                                    placeholder: UIImage(systemName: "person.crop.circle.fill"),
                                    options: [
                                        .processor(processor),
                                        .transition(.fade(1))
                                    ]
        )
    }
    
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 76),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            vStackView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            vStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            profileNameLabel.topAnchor.constraint(equalTo: vStackView.topAnchor),
            profileNameLabel.leadingAnchor.constraint(equalTo: vStackView.leadingAnchor),
            
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    
    private func setProfileViewLayout() {
        assert(Thread.isMainThread)
        view.backgroundColor = .ypBlack
        createViewOnVC(newView: avatarImageView, setIn: view)
        createViewOnVC(newView: vStackView, setIn: view)
        createViewOnVC(newView: logoutButton, setIn: view)
        activateConstraints()
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
