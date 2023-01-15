import Foundation

protocol OAuth2ServiceDelegate {
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void )
}

private enum OAuth2Error: Error {
    case codeError, decodeError
}

final class OAuth2Service: OAuth2ServiceDelegate {
    
    private let unsplashAuthorizeURLString = "https://unsplash.com/oauth/token"
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String? // значения code, которое было передано в последнем созданном запросе
    
    
    
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void ) {
        
        assert(Thread.isMainThread)  // Проверяем, что код выполняется из главного потока
        
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        var urlComponents = URLComponents(string: self.unsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: ConstantsUnsplash.accessKey),
            URLQueryItem(name: "client_secret", value: ConstantsUnsplash.secretKey),
            URLQueryItem(name: "redirect_uri", value: ConstantsUnsplash.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            
            if let error {
                completion(.failure(error))
                self.lastCode = nil
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300
            {
                completion(.failure(OAuth2Error.codeError))
                print("ERROR ------------------------------------------> bad code responce: \(response.statusCode)")
                return
            }
            
            guard let data else { return }
            
            do {
                let jsonResponce = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(jsonResponce.accessToken))
                    OAuth2TokenStorage().bearerToken = jsonResponce.accessToken
                    self.task = nil
                    print("GOOD -----------------------------------------> token save")
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(OAuth2Error.decodeError))
                    self.task = nil
                    print("ERROR ----------------------------------------> token decodeError")
                }
            }
        }
        self.task = task
        task.resume()
    }
}

