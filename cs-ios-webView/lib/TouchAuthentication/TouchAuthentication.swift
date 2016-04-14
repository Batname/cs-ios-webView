//
//  TouchAuthentication.swift
//  cs-ios-webView
//
//  Created by Денис Дубинин on 4/3/16.
//  Copyright © 2016 Denis Dubinin. All rights reserved.
//  https://github.com/marketplacer/keychain-swift

import CoreData
import LocalAuthentication
import Security
import KeychainSwift

class TouchAuthentication {
    
    typealias alertCbClosure = (String) -> Void
    let AppName: String
    var alertCallbacks: Dictionary<String, alertCbClosure> = [:]
    let keychain = KeychainSwift()
    let authenticationContext = LAContext()
    
    init (AppName: String) {
        self.AppName = AppName
        NSUserDefaults.standardUserDefaults().setValue(AppName, forKey: "appName")
    }
    
    func saveAuthData (login login: String, password: String) {
        
        if checkCredentialCorrectly(login, password:password) {
            print("login exists")
            return
        }

        keychain.set(password, forKey: "userPassword")
        NSUserDefaults.standardUserDefaults().setValue(login, forKey: "userLogin")
        
    }
    
    func checkCredentialCorrectly (login: String, password: String) -> Bool {
        if login == NSUserDefaults.standardUserDefaults().valueForKey("userLogin") as? String &&
            password == keychain.get("userPassword")! as String {
            return true
        } else {
            return false
        }
    }
    
    func checkCredentialAvailability () -> Bool {
        if NSUserDefaults.standardUserDefaults().valueForKey("userLogin") != nil &&
            keychain.get("userPassword") != nil {
                return true
        } else {
            return false
        }
    }
    
    func checkTouchIDAvailability () -> Bool {
        guard authenticationContext.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: nil) else {
            return false
        }
        return true
    }
    
    func addAuthLink () {
        checkFingerPrint()
        if checkTouchIDAvailability() && checkCredentialAvailability (){
            print("addAuthLink")
        }
    }
    
    private func checkFingerPrint () {
        authenticationContext.evaluatePolicy(.DeviceOwnerAuthentication, localizedReason: "Casino heroes auth here", reply: {
            (success, error) -> Void in
            
            if success {
                print("success touch id identifier")
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
    

    // add touch id
    // validate, handle http errors, success
    // is touch id exist
}