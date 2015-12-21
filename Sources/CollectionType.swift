import Foundation

#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

public extension CollectionType {

    typealias T = Generator.Element

    /// Returns elements of the collection that match the given regular expression.
    /// If elements are String or NSString instances they will be matched directly.
    /// if they are NSObject instances their -description is matched. Otherwise
    /// they are not matched.
    func grep(regex: String) throws -> [T] {
        let re = try NSRegularExpression(pattern: regex, options: NSRegularExpressionOptions(rawValue: 0))
        return filter({ item -> Bool in
            if let string = item as? String {
                return re.matches(string)
            }
            if let string = item as? NSString {
                return re.matches(String(string))
            }
            if let object = item as? NSObject {
                return re.matches(object.description)
            }
            return false
        })
    }

}

/// Returns a random integer between 1 and max
func randomInt(max: Int) -> Int {
    #if os(Linux)
        let n = random() % max
    #else
        let n = arc4random_uniform(UInt32(max))
    #endif
    return 1 + Int(n)
}

public extension CollectionType where Index: RandomAccessIndexType {

    /// Returns a random element, or nil if the collection is empty
    func sample() -> T? {
        guard !isEmpty else {
            return nil
        }
        let max = Int(count.toIntMax())
        let n = randomInt(max) - 1
        return self[startIndex.advancedBy(n)]
    }
    
}

public extension CollectionType where Self.Generator.Element: Equatable {

    /// Returns the unique elements of a sorted collection by collapsing runs of
    /// identical elements.
    func unique() -> [T] {
        var last: T?
        return filter({ item -> Bool in
            let isUnique: Bool = last == nil || last != item
            last = item
            return isUnique
        })
    }

}
