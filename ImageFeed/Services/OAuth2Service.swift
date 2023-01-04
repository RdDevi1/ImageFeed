import Foundation

protocol OAuth2ServiceDelegate {
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void )
}

private enum OAuth2Error: Error {
    case codeError, decodeError
}

final class OAuth2Service: OAuth2ServiceDelegate {
    
    private let unsplashAuthorizeURLString = "https://unsplash.com/oauth/token"
    
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void ) {
        
        let url = URL(string: unsplashAuthorizeURLString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error {
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300
            {
                completion(.failure(OAuth2Error.codeError))
                return
            }
            
            guard let data else { return }
            
            do {
                let jsonResponce = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(jsonResponce.accessToken))
                }
            } catch {
                completion(.failure(OAuth2Error.decodeError))
            }
        }
        task.resume()
    }
}

