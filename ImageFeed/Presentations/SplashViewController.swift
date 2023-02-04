import UIKit
import ProgressHUD


final class SplashViewController: UIViewController {
    
    private enum Constants {
        static let showAuthScreenSegueIdentifier = "ShowAuthentication"
        static let showTableSegueIdentifier = "ShowTable"
    }
    
    //MARK: - Properties
    private let oAuth2Service = OAuth2Service()
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var isAlreadyShownAuthScreen: Bool = false
    
    private lazy var splashLogoView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splash_screen_logo")
        return imageView
    }()
    
    
    //MARK: - LifeCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSplashViewLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard isAlreadyShownAuthScreen == false else { return }
        checkAuth()
    }
    
    
    //MARK: - Methods
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid configuration") }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
    
    
    private func checkAuth() {
        if let token = oAuth2TokenStorage.bearerToken {
            UIBlockingProgressHUD.show()
            fetchProfile(token: token)
            
        } else {
            
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            
            guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController
            else { return }
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        isAlreadyShownAuthScreen = true
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
        }
    }
}

// MARK: - Segue
extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.showAuthScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(Constants.showAuthScreenSegueIdentifier)") }
            
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

//MARK: - Fetch

extension SplashViewController {
    private func fetchOAuthToken(_ code: String) {
        oAuth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.oAuth2TokenStorage.bearerToken = token
                self.fetchProfile(token: token)
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                self.showAlert(title: "Что-то пошло не так(", message: "Не удалось войти в систему") { [weak self] _ in
                    self?.checkAuth()
                }
                print(error)
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.profileImageService.fetchProfileImageURL(username: profile.username) { _ in }
                DispatchQueue.main.async {
                    self.switchToTabBarController()
                }
            case .failure(let error):
                self.showAlert(title: "Что-то пошло не так(", message: "Не удалось войти в систему") { [weak self] _ in
                    self?.checkAuth()
                }
                print(error)
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}


// MARK: - Layout
extension SplashViewController {
    private func setSplashViewLayout() {
        view.backgroundColor = .ypBlack
        createViewOnVC(newView: splashLogoView, setIn: view)
        
        NSLayoutConstraint.activate([
            splashLogoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashLogoView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
