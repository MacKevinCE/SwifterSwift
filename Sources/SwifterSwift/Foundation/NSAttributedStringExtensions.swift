// NSAttributedStringExtensions.swift - Copyright 2020 SwifterSwift

#if canImport(Foundation)
import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

// MARK: - Properties

public extension NSAttributedString {
    /// SwifterSwift: Bolded string using the system font.
    #if !os(Linux)
    var bolded: NSAttributedString {
        guard !string.isEmpty else { return self }

        let pointSize: CGFloat
        if let font = attribute(.font, at: 0, effectiveRange: nil) as? SFFont {
            pointSize = font.pointSize
        } else {
            #if os(tvOS) || os(watchOS)
            pointSize = SFFont.preferredFont(forTextStyle: .headline).pointSize
            #else
            pointSize = SFFont.systemFontSize
            #endif
        }
        return applying(attributes: [.font: SFFont.boldSystemFont(ofSize: pointSize)])
    }
    #endif

    #if !os(Linux)
    /// SwifterSwift: Underlined string.
    var underlined: NSAttributedString {
        return applying(attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    #endif

    #if canImport(UIKit)
    /// SwifterSwift: Italicized string using the system font.
    var italicized: NSAttributedString {
        guard !string.isEmpty else { return self }

        let pointSize: CGFloat
        if let font = attribute(.font, at: 0, effectiveRange: nil) as? UIFont {
            pointSize = font.pointSize
        } else {
            #if os(tvOS) || os(watchOS)
            pointSize = UIFont.preferredFont(forTextStyle: .headline).pointSize
            #else
            pointSize = UIFont.systemFontSize
            #endif
        }
        return applying(attributes: [.font: UIFont.italicSystemFont(ofSize: pointSize)])
    }
    #endif

    #if !os(Linux)
    /// SwifterSwift: Struckthrough string.
    var struckthrough: NSAttributedString {
        return applying(attributes: [.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue)])
    }
    #endif

    /// SwifterSwift: Dictionary of the attributes applied across the whole string.
    var attributes: [Key: Any] {
        guard length > 0 else { return [:] }
        return attributes(at: 0, effectiveRange: nil)
    }
}

// MARK: - Methods

public extension NSAttributedString {
    /// SwifterSwift: Applies given attributes to the new instance of NSAttributedString initialized with self object.
    ///
    /// - Parameter attributes: Dictionary of attributes.
    /// - Returns: NSAttributedString with applied attributes.
    func applying(attributes: [Key: Any]) -> NSAttributedString {
        guard !string.isEmpty else { return self }

        let copy = NSMutableAttributedString(attributedString: self)
        copy.addAttributes(attributes, range: NSRange(0..<length))
        return copy
    }

    #if canImport(AppKit) || canImport(UIKit)
    /// SwifterSwift: Add color to NSAttributedString.
    ///
    /// - Parameter color: text color.
    /// - Returns: a NSAttributedString colored with given color.
    func colored(with color: SFColor) -> NSAttributedString {
        return applying(attributes: [.foregroundColor: color])
    }
    #endif

    /// SwifterSwift: Apply attributes to substrings matching a regular expression.
    ///
    /// - Parameters:
    ///   - attributes: Dictionary of attributes.
    ///   - pattern: a regular expression to target.
    ///   - options: The regular expression options that are applied to the expression during matching. See NSRegularExpression.Options for possible values.
    /// - Returns: An NSAttributedString with attributes applied to substrings matching the pattern.
    func applying(attributes: [Key: Any],
                  toRangesMatching pattern: String,
                  options: NSRegularExpression.Options = []) -> NSAttributedString {
        guard let pattern = try? NSRegularExpression(pattern: pattern, options: options) else { return self }

        let matches = pattern.matches(in: string, options: [], range: NSRange(0..<length))
        let result = NSMutableAttributedString(attributedString: self)

        for match in matches {
            result.addAttributes(attributes, range: match.range)
        }

        return result
    }

    /// SwifterSwift: Apply attributes to occurrences of a given string.
    ///
    /// - Parameters:
    ///   - attributes: Dictionary of attributes.
    ///   - target: a subsequence string for the attributes to be applied to.
    /// - Returns: An NSAttributedString with attributes applied on the target string.
    func applying<T: StringProtocol>(attributes: [Key: Any],
                                     toOccurrencesOf target: T) -> NSAttributedString {
        let pattern = "\\Q\(target)\\E"

        return applying(attributes: attributes, toRangesMatching: pattern)
    }
}

// MARK: - Operators

public extension NSAttributedString {
    /// SwifterSwift: Add a NSAttributedString to another NSAttributedString.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add to.
    ///   - rhs: NSAttributedString to add.
    static func += (lhs: inout NSAttributedString, rhs: NSAttributedString) {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        lhs = string
    }

    /// SwifterSwift: Add a NSAttributedString to another NSAttributedString and return a new NSAttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add.
    ///   - rhs: NSAttributedString to add.
    /// - Returns: New instance with added NSAttributedString.
    static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        return NSAttributedString(attributedString: string)
    }

    /// SwifterSwift: Add a NSAttributedString to another NSAttributedString.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add to.
    ///   - rhs: String to add.
    static func += (lhs: inout NSAttributedString, rhs: String) {
        lhs += NSAttributedString(string: rhs)
    }

    /// SwifterSwift: Add a NSAttributedString to another NSAttributedString and return a new NSAttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add.
    ///   - rhs: String to add.
    /// - Returns: New instance with added NSAttributedString.
    static func + (lhs: NSAttributedString, rhs: String) -> NSAttributedString {
        return lhs + NSAttributedString(string: rhs)
    }
}

public extension Array where Element: NSAttributedString {
    /// SwifterSwift: Returns a new `NSAttributedString` by concatenating the elements of the sequence, adding the given separator between each element.
    ///
    /// - Parameter separator: An `NSAttributedString` to add between the elements of the sequence.
    /// - Returns: NSAttributedString with applied attributes.
    // https://stackoverflow.com/questions/32830519/is-there-joinwithseparator-for-attributed-strings
    func joined(separator: NSAttributedString) -> NSAttributedString {
        guard let firstElement = first else { return NSMutableAttributedString(string: "") }
        return dropFirst().reduce(into: NSMutableAttributedString(attributedString: firstElement)) { result, element in
            result.append(separator)
            result.append(element)
        }
    }

    func joined(separator: String) -> NSAttributedString {
        guard let firstElement = first else { return NSMutableAttributedString(string: "") }
        let attributedStringSeparator = NSAttributedString(string: separator)
        return dropFirst().reduce(into: NSMutableAttributedString(attributedString: firstElement)) { result, element in
            result.append(attributedStringSeparator)
            result.append(element)
        }
    }
}

// MARK: - Package

public extension NSMutableAttributedString {
    @discardableResult
    func applying(attributes: [NSAttributedString.Key: Any], range: NSRange) -> NSMutableAttributedString {
        addAttributes(attributes, range: range)
        return self
    }

    @discardableResult
    func colored(with color: SFColor, range: NSRange) -> NSMutableAttributedString {
        applying(attributes: [.foregroundColor: color], range: range)
    }

    @discardableResult
    func backgroundColored(with backgroundColor: SFColor, range: NSRange) -> NSMutableAttributedString {
        applying(attributes: [.backgroundColor: backgroundColor], range: range)
    }

    @discardableResult
    func fonted(with font: SFFont, range: NSRange) -> NSMutableAttributedString {
        applying(attributes: [.font: font], range: range)
    }

    @discardableResult
    func underlined(range: NSRange) -> NSMutableAttributedString {
        applying(attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue], range: range)
    }

    @discardableResult
    func struckthrough(range: NSRange) -> NSMutableAttributedString {
        applying(attributes: [.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue as Int)], range: range)
    }

    @discardableResult
    func indented(with indentation: CGFloat, range: NSRange) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        let nonOptions = [NSTextTab.OptionKey: Any]()
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: indentation, options: nonOptions)]
        paragraphStyle.defaultTabInterval = indentation
        paragraphStyle.headIndent = indentation
        return applying(attributes: [.paragraphStyle: paragraphStyle], range: range)
    }

    @discardableResult
    func applying(range: NSRange, font: SFFont? = nil, color: SFColor? = nil, backgroundColor: SFColor? = nil, indentation: CGFloat? = nil, isUnderline: Bool = false, isStruckthrough: Bool = false) -> NSMutableAttributedString {
        if let font = font {
            fonted(with: font, range: range)
        }
        if let color = color {
            colored(with: color, range: range)
        }
        if let backgroundColor = backgroundColor {
            backgroundColored(with: backgroundColor, range: range)
        }
        if let indentation = indentation {
            indented(with: indentation, range: range)
        }
        if isUnderline {
            underlined(range: range)
        }
        if isStruckthrough {
            struckthrough(range: range)
        }
        return self
    }

    @discardableResult
    func applying(ranges: [NSRange], font: SFFont? = nil, color: SFColor? = nil, backgroundColor: SFColor? = nil, indentation: CGFloat? = nil, isUnderline: Bool = false, isStruckthrough: Bool = false) -> NSMutableAttributedString {
        ranges.forEach {
            applying(range: $0, font: font, color: color, backgroundColor: backgroundColor, indentation: indentation, isUnderline: isUnderline, isStruckthrough: isStruckthrough)
        }
        return self
    }

    @discardableResult
    func applying(font: SFFont? = nil, color: SFColor? = nil, backgroundColor: SFColor? = nil, indentation: CGFloat? = nil, isUnderline: Bool = false, isStruckthrough: Bool = false) -> NSMutableAttributedString {
        let range = (string as NSString).range(of: string)
        return applying(range: range, font: font, color: color, backgroundColor: backgroundColor, indentation: indentation, isUnderline: isUnderline, isStruckthrough: isStruckthrough)
    }

    @available(iOS 16.0, *)
    @discardableResult
    func applying(toOccurrencesOf textFind: String, font: SFFont? = nil, color: SFColor? = nil, backgroundColor: SFColor? = nil, indentation: CGFloat? = nil, isUnderline: Bool = false, isStruckthrough: Bool = false) -> NSMutableAttributedString {
        if textFind != "" {
            let ranges = string.ranges(of: textFind)
            applying(ranges: ranges, font: font, color: color, backgroundColor: backgroundColor, indentation: indentation, isUnderline: isUnderline, isStruckthrough: isStruckthrough)
        }
        return self
    }

    @discardableResult
    func applying(textFind: String, font: SFFont? = nil, color: SFColor? = nil, backgroundColor: SFColor? = nil, indentation: CGFloat? = nil, isUnderline: Bool = false, isStruckthrough: Bool = false) -> NSMutableAttributedString {
        if textFind != "" {
            let range = (string as NSString).range(of: textFind)
            applying(range: range, font: font, color: color, backgroundColor: backgroundColor, indentation: indentation, isUnderline: isUnderline, isStruckthrough: isStruckthrough)
        }
        return self
    }

    @discardableResult
    func addTextApplying(text: String, font: SFFont? = nil, color: SFColor? = nil, backgroundColor: SFColor? = nil, indentation: CGFloat? = nil, isUnderline: Bool = false, isStruckthrough: Bool = false) -> NSMutableAttributedString {
        if text != "" {
            let attributedString = text.applying(font: font, color: color, backgroundColor: backgroundColor, indentation: indentation, isUnderline: isUnderline, isStruckthrough: isStruckthrough)
            append(attributedString)
        }
        return self
    }
}

public extension String {
    func applying(attributes: [NSAttributedString.Key: Any]) -> NSMutableAttributedString {
        NSMutableAttributedString(string: self, attributes: attributes)
    }

    func colored(with color: SFColor) -> NSMutableAttributedString {
        applying(attributes: [.foregroundColor: color])
    }

    func backgroundColored(with backgroundColor: SFColor) -> NSMutableAttributedString {
        applying(attributes: [.backgroundColor: backgroundColor])
    }

    func fonted(with font: SFFont) -> NSMutableAttributedString {
        applying(attributes: [.font: font])
    }

    func underlined() -> NSMutableAttributedString {
        applying(attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }

    func struckthrough() -> NSMutableAttributedString {
        applying(attributes: [.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue as Int)])
    }

    func indented(with indentation: CGFloat) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        let nonOptions = [NSTextTab.OptionKey: Any]()
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: indentation, options: nonOptions)]
        paragraphStyle.defaultTabInterval = indentation
        paragraphStyle.headIndent = indentation
        return applying(attributes: [.paragraphStyle: paragraphStyle])
    }

    func applying(font: SFFont? = nil, color: SFColor? = nil, backgroundColor: SFColor? = nil, indentation: CGFloat? = nil, isUnderline: Bool = false, isStruckthrough: Bool = false) -> NSMutableAttributedString {
        NSMutableAttributedString(string: self).applying(font: font, color: color, backgroundColor: backgroundColor, indentation: indentation, isUnderline: isUnderline, isStruckthrough: isStruckthrough)
    }
    
    func ranges(of textFind: String, options mask: NSString.CompareOptions = []) -> [NSRange] {
        var ranges: [NSRange] = []

        var range = NSRange(location: 0, length: count)
        while range.location != NSNotFound {
            range = NSMutableString(string: self).range(of: textFind, options: mask, range: range)
            if range.location != NSNotFound {
                ranges.append(range)
                let location = range.location + range.length
                range = NSRange(location: location, length: count - location)
            }
        }
        return ranges
    }
}

#endif
