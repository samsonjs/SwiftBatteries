import Foundation

public extension CollectionType {

    /// Returns elements of the collection that match the given regular expression.
    /// If elements are String or NSString instances they will be matched directly.
    /// if they are NSObject instances their -description is matched. Otherwise
    /// they are not matched.
    func grep(regex: String) throws -> [Generator.Element] {
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

public extension CollectionType where Index: RandomAccessIndexType {

    /// Returns a random element, or nil if the collection is empty
    func sample() -> Generator.Element? {
        guard !isEmpty else {
            return nil
        }
        let n = Int(count.toIntMax())
        let i = startIndex.advancedBy(Index.Distance(IntMax(randomInt(n) - 1)))
        return self[i]
    }
    
}

public extension CollectionType where Generator.Element: Equatable {

    /// Returns the unique elements of a sorted collection by collapsing runs of
    /// identical elements.
    func unique() -> [Generator.Element] {
        var last: Generator.Element?
        return filter({ item -> Bool in
            let isUnique: Bool = last == nil || last != item
            last = item
            return isUnique
        })
    }

}
