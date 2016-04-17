
import KeychainSwift

struct AuthStorage {
    
    private var valueForKey: (String) -> AnyObject? = NSUserDefaults.standardUserDefaults().valueForKey
    private let keychain = KeychainSwift()

    var AppName: String? {
        get {
            return valueForKey("AppName") as? String
        }
        set(AppName) {
            NSUserDefaults.standardUserDefaults().setValue(AppName, forKey: "AppName")
        }
    }

    var login: String? {
        get {
            return valueForKey("userLogin") as? String
        }
        set(login) {
            NSUserDefaults.standardUserDefaults().setValue(login, forKey: "userLogin")
        }
    }
    
    var password: String? {
        get {
            return keychain.get("userPassword")! as String
        }
        set(password) {
            if let password = password {
                keychain.set(password, forKey: "userPassword")
            }
        }
    }
}