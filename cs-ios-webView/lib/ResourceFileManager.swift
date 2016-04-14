//
//  ResourceFileManager.swift
//  cs-ios-webView
//
//  Created by Денис Дубинин on 4/14/16.
//  Copyright © 2016 Denis Dubinin. All rights reserved.
//

struct ResourceFileManager {
    func getAsString (fileName: String, encoding: String) -> String? {
        if let filepath = NSBundle.mainBundle().pathForResource(fileName, ofType: encoding) {
            do {
                let contents = try NSString(contentsOfFile: filepath, usedEncoding: nil) as String
                return contents
            } catch let error as NSError {
                print(error.code)
                return nil
            }
        } else {
            return  nil
        }
    }
}
