
import LocalAuthentication
import KeychainSwift
import WebKit

class TouchAuthentication {

    typealias alertCbClosure = (String) -> Void

    private let AppName: String
    private let keychain = KeychainSwift()
    private let authenticationContext = LAContext()
    
    var alertCallbacks: Dictionary<String, alertCbClosure> = [:]
    var webView: WKWebView?
    
    init (AppName: String) {
        self.AppName = AppName
        NSUserDefaults.standardUserDefaults().setValue(AppName, forKey: "appName")
    }
    
    private func checkCredentialCorrectly (login: String, password: String) -> Bool {
        if login == NSUserDefaults.standardUserDefaults().valueForKey("userLogin") as? String &&
            password == keychain.get("userPassword")! as String {
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
        if NSUserDefaults.standardUserDefaults().valueForKey("userLogin") != nil &&
            keychain.get("userPassword") != nil {
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
            keychain.set(password, forKey: "userPassword")
            NSUserDefaults.standardUserDefaults().setValue(login, forKey: "userLogin")
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
            
            if let (login, password, webView) = unwrap(NSUserDefaults.standardUserDefaults().valueForKey("userLogin"), self.keychain.get("userPassword"), self.webView) where success {
                    
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