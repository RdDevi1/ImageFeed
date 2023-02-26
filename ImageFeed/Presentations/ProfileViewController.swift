import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateProfileDetails(profile: Profile?)
    func showAlert(title: String,
                   message: String,
                   action: ((UIAlertAction) -> (Void))?
    )
}


final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    var presenter: ProfilePresenterProtocol?
    
    private var profileService = ProfileService.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private let avatarImageViewGradient = CAGradientLayer()
    private let profileNameLabelGradient = CAGradientLayer()
    private let loginLabelGradient = CAGradientLayer()
    private let descriptionLabelGradient = CAGradientLayer()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 35
        return imageView
    }()
    
    private lazy var profileNameLabel: UILabel = {
        let label = UILabel()
        label.text = "     "
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textColor = .white
        return label
    }()
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "     "
        label.font = UIFont(name: "System", size: 13)
        label.textColor = .ypGray
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "     "
        label.font = UIFont(name: "System", size: 13)
        label.textColor = .white
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        button.setImage(UIImage(named: "logout_button"), for: .normal)
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
        super.viewDidLoad()
        setProfileViewLayout()
        presenter?.viewDidLoad()
        
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if profileService.profile == nil {
            profileNameLabelGradient.frame.size.width = 223
            profileNameLabelGradient.frame.size.height = 23
            loginLabelGradient.frame.size.width = 89
            loginLabelGradient.frame.size.height = 18
            descriptionLabelGradient.frame.size.width = 67
            descriptionLabelGradient.frame.size.height = 18
            profileNameLabel.addGradient(gradient: profileNameLabelGradient, cornerRadius: 9)
            loginLabel.addGradient(gradient: loginLabelGradient, cornerRadius: 9)
            descriptionLabel.addGradient(gradient: descriptionLabelGradient, cornerRadius: 9)
        }
        if profileImageService.avatarURL == nil {
            avatarImageViewGradient.frame.size.width = 70
            avatarImageViewGradient.frame.size.height = 70
            avatarImageView.addGradient(gradient: avatarImageViewGradient, cornerRadius: 35)
        }
    }
    
    
    // MARK: - Private methods
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        avatarImageView.removeGradient(gradient: avatarImageViewGradient)
        avatarImageView.kf.setImage(with: url)
    }
    
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            vStackView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            vStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            profileNameLabel.topAnchor.constraint(equalTo: vStackView.topAnchor),
            profileNameLabel.leadingAnchor.constraint(equalTo: vStackView.leadingAnchor),
            
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
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
    
    
    @objc
    private func didTapLogoutButton() {
        guard let alert = presenter?.logoutAlert() else { return }
        present(alert, animated: true)
    }
    
    
    func configure(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }
}


// MARK: - Update profile

extension ProfileViewController {
    
     func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else { return }
        profileNameLabel.removeGradient(gradient: profileNameLabelGradient)
        loginLabel.removeGradient(gradient: loginLabelGradient)
        descriptionLabel.removeGradient(gradient: descriptionLabelGradient)
        profileNameLabel.text = profile.name
        loginLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
}
