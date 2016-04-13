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
    
    let AppName: String
    let keychain = KeychainSwift()
    
    init (AppName: String) {
        self.AppName = AppName
        NSUserDefaults.standardUserDefaults().setValue(AppName, forKey: "appName")
    }
    
    func saveAuthData (login login: String, password: String) {
        
        if checkLogin(login, password:password) {
            print("login exists")
            return
        }

        keychain.set(password, forKey: "userPassword")
        NSUserDefaults.standardUserDefaults().setValue(login, forKey: "userLogin")
        
    }
    
    func checkLogin (login: String, password: String) -> Bool {
        if login == NSUserDefaults.standardUserDefaults().valueForKey("userLogin") as? String &&
            password == keychain.get("userPassword")! as String {
            return true
        } else {
            return false
        }
    }

    // add touch id
    // validate, handle http errors, success
    // is touch id available
    // is touch id exist
}