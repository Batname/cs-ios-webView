
import LocalAuthentication
import WebKit

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
                    
                let touchAuthorizeJs:String
                    = "(function () {\n" +
                        "     var login = '\(login)';\n" +
                        "     var password = '\(password)';\n" +
                        "     var isCalled = false;\n" +
                        "     function touchAuthorize (callback) {\n" +
                        "         if (!isCalled) { callback(login, password); isCalled = true; }\n" +
                        "     };\n" +
                        "     window.rootScope.native.touchAuthorize = touchAuthorize;\n" +
                        "})();\n"
                    
                webView.evaluateJavaScript(touchAuthorizeJs, completionHandler: WebViewJsEvaluator.errorHandler)
                    
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