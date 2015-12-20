import Foundation

public extension String {

    func contains(substring: String) -> Bool {
        return rangeOfString(substring) != nil
    }

    func trim() -> String {
        return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }

}
