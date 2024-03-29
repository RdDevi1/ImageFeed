import Foundation

private enum OAuth2Error: Error {
    case codeError, decodeError
}

final class OAuth2Service: OAuth2ServiceDelegate {
    
    // MARK: - Properties
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String? // значения code, которое было передано в последнем созданном запросе
    
    // MARK: - Methods
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void ) {
        
        assert(Thread.isMainThread)  // Проверяем, что код выполняется из главного потока
        
        guard lastCode != code else { return }
        task?.cancel()
        lastCode = code
        guard let request = makeRequest(code: code) else { return }
        
        let task = urlSession.objectTask(for: request) { (result: Result<OAuthTokenResponseBody, Error>) in
            
            switch result {
            case .success(let jsonData):
                completion(.success(jsonData.accessToken))
                self.task = nil
                print("SUCCESS --> token is here")
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    
    private func makeRequest(code: String) -> URLRequest? {
        
        if var urlComponents = URLComponents(string: Constants.tokenURL) {
            urlComponents.queryItems = [
                URLQueryItem(name: "client_id", value: Constants.accessKey),
                URLQueryItem(name: "client_secret", value: Constants.secretKey),
                URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
                URLQueryItem(name: "code", value: code),
                URLQueryItem(name: "grant_type", value: "authorization_code")
            ]
            var request = URLRequest(url: urlComponents.url!)
            request.httpMethod = "POST"
            return request
        }
        return nil
    }
}
