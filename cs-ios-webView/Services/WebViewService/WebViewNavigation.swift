import WebKit

class WebViewNavigation {
    
    let auth: TouchAuthentication
    let url: NSURL
    var webView: WKWebView
    private let injectorJsFile: String?
    
    init(url: NSURL, auth: TouchAuthentication, webView: WKWebView) {
        self.url = url
        self.auth = auth
        self.webView = webView
        self.injectorJsFile = ResourceFileService.getAsString("injector", encoding: "js")
    }
    
    func urlAction () {
    
        if let injectorJsFile = self.injectorJsFile {
            webView.evaluateJavaScript(injectorJsFile, completionHandler: WebViewJsEvaluator.errorHandler)
        }
        
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