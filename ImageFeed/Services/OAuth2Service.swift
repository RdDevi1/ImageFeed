import Foundation

protocol OAuth2ServiceDelegate {
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void )
}

private enum OAuth2Error: Error {
    case codeError, decodeError
}

final class OAuth2Service: OAuth2ServiceDelegate {
    
    // MARK: - Properties
    private let unsplashAuthorizeURLString = "https://unsplash.com/oauth/token"
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String? // значения code, которое было передано в последнем созданном запросе
    
    
    
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void ) {
        
        assert(Thread.isMainThread)  // Проверяем, что код выполняется из главного потока
        
        guard lastCode != code else { return }
        task?.cancel()
        lastCode = code
        
        
        let request = makeRequest(code: code)
        
        let task = urlSession.objectTask(for: request) { (result: Result<OAuthTokenResponseBody, Error>) in
            
            switch result {
            case .success(let jsonData):
                completion(.success(jsonData.accessToken))
                self.task = nil
                print("SUCCESS--------------------> token is here")
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    
    private func makeRequest(code: String) -> URLRequest {
        
        guard let url = URL(string: unsplashAuthorizeURLString) else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        
        var urlComponents = URLComponents(string: self.unsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: ConstantsUnsplash.accessKey),
            URLQueryItem(name: "client_secret", value: ConstantsUnsplash.secretKey),
            URLQueryItem(name: "redirect_uri", value: ConstantsUnsplash.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        request.httpMethod = "POST"
        return request
    }
    
}

