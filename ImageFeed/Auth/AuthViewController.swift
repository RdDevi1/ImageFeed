import UIKit
import ProgressHUD

fileprivate let showWebViewSegueIdentifier = "ShowWebView"

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var authLogoImage: UIImageView!
    @IBOutlet private weak var logInButton: UIButton!
    
    
    // MARK: - Properties
    weak var delegate: AuthViewControllerDelegate?
    private let oAuth2Service = OAuth2Service()
    private var oAuth2TokenStorage = OAuth2TokenStorage.shared
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController
            else  { fatalError("Failed to prepare for \(showWebViewSegueIdentifier)") }
            let webViewPresenter = WebViewPresenter()
            webViewViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewViewController
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
}

//MARK: - Extensions
extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
}

