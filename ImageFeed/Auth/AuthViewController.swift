import UIKit

final class AuthViewController: UIViewController {
    
    private enum Constants {
        static let showWebViewSegueIdentifier = "ShowWebView"
    }
    
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
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
}
