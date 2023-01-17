import Foundation

private enum ProfileError: Error {
    case codeError, decodeError, error
}


final class ProfileService {
  
    // MARK: - Properties
    fileprivate let profileInfoURLString = "https://api.unsplash.com/me"
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    private(set) var profile: Profile?
    
    // MARK: - Singleton
    static let shared = ProfileService()
    private init() {}
    
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        
        if lastToken == token { return }
        task?.cancel()
        lastToken = token
        
        let request = self.makeRequest(token: token)

        let task = urlSession.objectTask(for: request) { (result: Result<ProfileResult, Error>) in
            
            switch result {
            case .success(let jsonData):
                let profile = Profile(
                    username: jsonData.username,
                    name: "\(jsonData.firstName) \(jsonData.lastName)",
                    loginName: "@\(jsonData.username)",
                    bio: jsonData.bio
                )
                self.profile = profile
                completion(.success(profile))
                print("SUCCESS--------------------> profile is here")
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    
    private func makeRequest(token: String) -> URLRequest {
        guard let url = URL(string: profileInfoURLString) else { fatalError("Failed to create URL") }
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            return request
        }
    
}

