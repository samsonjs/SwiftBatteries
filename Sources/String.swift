import Foundation

public extension String {

    // Check if this string contains the given string.
    func contains(substring: String) -> Bool {
        return rangeOfString(substring) != nil
    }

    // Check if this string matches the given regular expression.
    func matches(regex: String) -> Bool {
        return rangeOfString(regex, options:.RegularExpressionSearch) != nil
    }

    // Match the given regular expression against this string and return all
    // the results.
    func match(regex: String) throws -> [NSTextCheckingResult] {
        let re = try NSRegularExpression(pattern: regex, options: NSRegularExpressionOptions(rawValue: 0))
        return re.match(self)
    }

    func substringWithNSRange(range: NSRange) -> String {
        let start = startIndex.advancedBy(range.location)
        let end = start.advancedBy(range.length)
        return substringWithRange(Range(start:start, end:end))
    }

    // Trim whitespace and newlines from the beginning and end of this string.
    func trim() -> String {
        return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }

}
