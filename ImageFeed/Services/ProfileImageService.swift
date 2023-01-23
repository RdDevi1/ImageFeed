import Foundation

private enum ProfileImageError: Error {
    case codeError, decodeError, error
}

final class ProfileImageService {
    
    //MARK: - Properties
    private let userImagesURLString  = "https://api.unsplash.com/me"
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var oAuth2TokenStorage = OAuth2TokenStorage()
    private(set) var avatarURL: String?
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    //MARK: - Singleton
    static let shared = ProfileImageService()
    private init() {}
    
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        task?.cancel()
        
        let request = self.makeRequest(username: username, token: oAuth2TokenStorage.bearerToken)
        
        let task = urlSession.objectTask(for: request) { (result: Result<UserResult, Error>) in
            
            switch result {
            case .success(let jsonData):
                let profileImageURL = jsonData.profileImage.small
                self.avatarURL = profileImageURL
                completion(.success(profileImageURL))
                print("SUCCESS--------------------> profileImageURL is here")
                
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": profileImageURL]
                )
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
    
    
    private func makeRequest(username: String, token: String?) -> URLRequest {
        guard let url = URL(string: userImagesURLString) else { fatalError("Failed to create URL") }
        guard let token = oAuth2TokenStorage.bearerToken else { fatalError("No token provided") }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}
