import Foundation

public extension NSRegularExpression {

    func match(string: String) -> [NSTextCheckingResult] {
        let range = NSRange(location: 0, length: string.characters.count)
        return self.matchesInString(string, options: NSMatchingOptions(rawValue: 0), range: range)
    }

    func matches(string: String) -> Bool {
        return self.match(string).count > 0
    }

}
