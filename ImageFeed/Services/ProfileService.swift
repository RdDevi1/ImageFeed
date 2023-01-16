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

        let task = urlSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    
                }
                if let response = response as? HTTPURLResponse,
                   response.statusCode < 200 || response.statusCode > 299 {
                    completion(.failure(ProfileError.codeError))
                }
                
                guard let data = data else { return }
                
                do {
                    let jsonData = try JSONDecoder().decode(ProfileResult.self, from: data)
                    
                    let profile = Profile(
                        username: jsonData.username,
                        name: "\(jsonData.firstName) \(jsonData.lastName)",
                        loginName: "@\(jsonData.username)",
                        bio: jsonData.bio
                    )
                    self.profile = profile
                    completion(.success(profile))
                    print("GOOD ---------------------------------------> profile in profile")
                } catch {
                    completion(.failure(ProfileError.decodeError))
                    self.lastToken = nil
                    print(" ERROR -------------------------------------->  profile lost ")
                }
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

