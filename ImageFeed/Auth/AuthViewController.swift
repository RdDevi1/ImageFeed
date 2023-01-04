import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    
    weak var delegate: AuthViewControllerDelegate?
    private enum Constants {
        static let showWebViewSegueIdentifier = "ShowWebView"
    }
    
    private let oAuth2Service = OAuth2Service()
    private var oAuth2TokenStorage = OAuth2TokenStorage()
    
    @IBOutlet weak var authLogoImage: UIImageView!
    @IBOutlet weak var logInButton: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  Constants.showWebViewSegueIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController
            else  { fatalError("Failed to prepare for \(Constants.showWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
}

extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
        oAuth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let token):
                self.oAuth2TokenStorage.bearerToken = token
                print("token is here: \(self.oAuth2TokenStorage.bearerToken ?? "nil")")

            case .failure(let error):
                print(error)
            }
        }
    }
}

