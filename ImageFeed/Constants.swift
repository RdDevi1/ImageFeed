import Foundation


enum Constants {
    static let accessKey = "G01AvKEjsglF0cDxduc1lJ9r2jMeoKWJa5SpgHz5mng"
    static let secretKey = "bNueCQoswZf3y206QSYI9hgtl9Eg5q66O7sU8Brae3o"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    //static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    
    static let defaultBaseURL = "https://api.unsplash.com"
    static let tokenURL = "https://unsplash.com/oauth/token"
    static let profileURL = "\(defaultBaseURL)/me"
    static let profileImageURL = "\(defaultBaseURL)/users"
    static let photoURL =  "\(defaultBaseURL)/photos"
}
