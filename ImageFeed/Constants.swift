import Foundation



let accessKey = "G01AvKEjsglF0cDxduc1lJ9r2jMeoKWJa5SpgHz5mng"
let secretKey = "bNueCQoswZf3y206QSYI9hgtl9Eg5q66O7sU8Brae3o"
let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
let accessScope = "public+read_user+write_likes"
//static let defaultBaseURL = URL(string: "https://api.unsplash.com")!

let defaultBaseURL = "https://api.unsplash.com"
let tokenURL = "\(defaultBaseURL)/oauth/token"
let profileURL = "\(defaultBaseURL)/me"
let profileImageURL = "\(defaultBaseURL)/users"
let photoURL =  "\(defaultBaseURL)/photos"

