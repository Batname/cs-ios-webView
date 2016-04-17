import WebKit
import Stencil

class WebViewNavigation {
    
    let auth: TouchAuthentication
    let url: NSURL
    var webView: WKWebView
    
    init(url: NSURL, auth: TouchAuthentication, webView: WKWebView) {
        self.url = url
        self.auth = auth
        self.webView = webView
    }
    
    func urlAction () {
        
        do {
            let template = try Template(named: "injector.js")
            let rendered = try template.render()
            webView.evaluateJavaScript(rendered, completionHandler: WebViewJsEvaluator.errorHandler)
        } catch {
            print("Failed to render template \(error)")
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