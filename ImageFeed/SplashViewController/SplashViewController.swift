import UIKit
import ProgressHUD


final class SplashViewController: UIViewController {
    
    private enum Constants {
        static let showAuthScreenSegueIdentifier = "ShowAuthentication"
        static let showTableSegueIdentifier = "ShowTable"
    }
    
    //MARK: - Properties
    private let oAuth2Service = OAuth2Service()
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    let splashLogoView = UIImageView()
    
    
    
    //MARK: - LifeCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSplashViewLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
    
    
    //MARK: - Methods
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid configuration") }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
}


extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        switchToTabBarController()
        vc.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
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
                self.showAlert(vc: self)
                print(error)
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                DispatchQueue.main.async {
                    self.profileImageService.fetchProfileImageURL(username: profile.username) { _ in }
                    self.switchToTabBarController()
                }
            case .failure(let error):
                self.showAlert(vc: self)
                print(error)
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}

// MARK: - Alert
extension SplashViewController {
    func showAlert(vc: UIViewController) {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )
        let alertAction = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(alertAction)
        vc.present(self, animated: true)
    }
}


// MARK: - Layout
extension SplashViewController {
    private func setSplashViewLayout() {
        view.backgroundColor = .ypBlack
        splashLogoView.image = UIImage(named: "splash_screen_logo")
        createViewOnVC(newView: splashLogoView, setIn: view)
        
        NSLayoutConstraint.activate([
            splashLogoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashLogoView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

