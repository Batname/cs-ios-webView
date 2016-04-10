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
    var AppLogin: String?
    var AppPassword: String?
    let keychain = KeychainSwift()
    
    let MyKeychainWrapper = KeychainWrapper()
    
    init (AppName: String) {
        self.AppName = AppName
    }
    
    func saveAuthData (login login: String?, password: String?) {
    
        AppLogin = login
        AppPassword = password
        
        print(keychain.get("userPassword"))
        keychain.set(AppPassword!, forKey: "userPassword")
        
    }

    // add touch id
    // validate, handle http errors, success
    // change password
    // is touch id available
    // is touch id exist
}