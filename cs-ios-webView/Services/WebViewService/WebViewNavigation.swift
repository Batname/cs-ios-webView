
class WebViewNavigation {
    
    let auth: TouchAuthentication
    let url: NSURL
    
    init(url: NSURL, auth: TouchAuthentication) {
        self.url = url
        self.auth = auth
    }
    
    func urlAction () {
        switch url.host {
        case "authorized"? :
            if let (login, password) = unwrap(url.queryDictionary?["login"]?.first, url.queryDictionary?["password"]?.first) {
                self.auth.saveAuthData(login: login, password: password)
            }
        case "reauthenticated"? :
            print("reauthenticated")
        case "notauthorized"? :
            self.auth.addAuthLink()
            print("notauthorized")
        case "touchIdAuth"? :
            self.auth.checkFingerPrint();
            print("checkFingerPrint")
        case "logout"? :
            self.auth.addAuthLink()
            print("logout")
        default: break
        }
    }
    
}