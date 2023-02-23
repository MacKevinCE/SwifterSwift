//
//  BundleExtensions.swift
//  SwifterSwift
//
//  Created by Mc Kevin on 15/06/23.
//  Copyright © 2023 SwifterSwift
//

// MARK: - Package

public extension Bundle {
    class func myResourceBundle(for aClass: AnyClass) -> Bundle? {
        return myResourceBundle(for: aClass, subdirectory: String(describing: aClass))
    }
    
    class func myResourceBundle(for aClass: AnyClass, subdirectory: String) -> Bundle? {
        let resourceURL = Bundle(for: aClass).resourcePath ?? ""
        let path = "\(resourceURL)/\(subdirectory).bundle"
        return Bundle(path: path)
    }
}
