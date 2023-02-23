//
//  EncodableExtensions.swift
//  SwifterSwift
//
//  Created by Mc Kevin on 15/06/23.
//  Copyright © 2023 SwifterSwift
//

import Foundation

// MARK: - Package

public extension Encodable {
    func encode() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
}
