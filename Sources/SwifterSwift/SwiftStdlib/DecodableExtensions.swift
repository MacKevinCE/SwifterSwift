// DecodableExtensions.swift - Copyright 2020 SwifterSwift

#if canImport(Foundation)
import Foundation
#endif

// MARK: - Package
public extension Decodable {
    #if canImport(Foundation)
    /// SwifterSwift: Parsing the model in Decodable type.
    /// - Parameters:
    ///   - data: Data.
    ///   - decoder: JSONDecoder. Initialized by default.
    init(from data: Data, using decoder: JSONDecoder = .init()) throws {
        let parsed = try decoder.decode(Self.self, from: data)
        self = parsed
    }
    #endif
}
