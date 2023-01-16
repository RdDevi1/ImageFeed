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
    private(set) var avatarUrl: String?
    
    //MARK: - Singleton
    static let shared = ProfileImageService()
    private init() {}
    
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        task?.cancel()
        
        let request = self.makeRequest(username: username, token: oAuth2TokenStorage.bearerToken)
        
        let task = urlSession.dataTask(with: request) { data, responce, error in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                if let error {
                    completion(.failure(error))
                    return
                }
                
                if let response = responce as? HTTPURLResponse,
                   response.statusCode < 200 || response.statusCode > 299 {
                    completion(.failure(ProfileImageError.codeError))
                    print("ERROR ------------------------------------------> bad code responce: \(response.statusCode)")
                }
                
                guard let data else { return }
                
                do {
                    let jsonData = try JSONDecoder().decode(UserResult.self, from: data)
                    let avatarURL = jsonData.profileImage.small
                    self.avatarUrl = avatarURL
                    completion(.success(avatarURL))
                    print("GOOD ----------------------------------------> avatarURL is here")
                } catch {
                    completion(.failure(ProfileImageError.decodeError))
                    print("ERROR ----------------------------------------> avatarURL decodeError")
                }
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
