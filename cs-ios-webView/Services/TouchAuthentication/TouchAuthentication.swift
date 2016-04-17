
import LocalAuthentication
import WebKit
import Stencil

class TouchAuthentication {

    typealias alertCbClosure = (String) -> Void

    private let AppName: String
    private let authenticationContext = LAContext()
    private var authStorage = AuthStorage()
    
    var alertCallbacks: Dictionary<String, alertCbClosure> = [:]
    var webView: WKWebView?
    
    init (AppName: String) {
        self.AppName = AppName
        authStorage.AppName = AppName
    }
    
    private func checkCredentialCorrectly (login: String, password: String) -> Bool {
        if login == authStorage.login &&
            password == authStorage.password {
                return true
        } else {
            return false
        }
    }
    
    private func checkTouchIDAvailability () -> Bool {
        guard authenticationContext.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: nil) else {
            return false
        }
        return true
    }
    
    private func checkCredentialAvailability () -> Bool {
        if authStorage.login != nil &&
            authStorage.password != nil {
                return true
        } else {
            return false
        }
    }
    
    func saveAuthData (login login: String, password: String) {
        
        if let webView = self.webView {
            webView.evaluateJavaScript("window.rootScope.native.TouchAuthActive = false", completionHandler: WebViewJsEvaluator.errorHandler)
        }
        
        if checkCredentialCorrectly(login, password:password) {
            print("login exists")
            return
        } else {
            authStorage.password = password
            authStorage.login = login
        }
    }
    
    func addAuthLink () {
        if let webView = self.webView where checkTouchIDAvailability() && checkCredentialAvailability() {
            webView.evaluateJavaScript("window.rootScope.native.TouchAuthActive = true", completionHandler: WebViewJsEvaluator.errorHandler)
        }
    }

    func checkFingerPrint () {
        authenticationContext.evaluatePolicy(.DeviceOwnerAuthentication, localizedReason: "Casino heroes auth here", reply: {
            (success, error) -> Void in
            
            if let (login, password, webView) = unwrap(self.authStorage.login, self.authStorage.password, self.webView) where success {
                
                let context = Context(dictionary:["password": password, "login": login])
                
                do {
                    let template = try Template(named: "touchAuthorize.js")
                    let rendered = try template.render(context)
                    webView.evaluateJavaScript(rendered, completionHandler: WebViewJsEvaluator.errorHandler)
                } catch {
                    print("Failed to render template \(error)")
                }
                
            } else {
                if let error = error {
                    let message = self.errorMessageForLAErrorCode(error.code)
                    if let showAlertWithTitle = self.alertCallbacks["showAlertWithTitle"] {
                        showAlertWithTitle(message)
                    }
                }
            }
        })
    }
}