#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

/// Returns a random integer between 1 and max, inclusive.
public func randomInt(max: Int) -> Int {
    #if os(Linux)
        let n = random() % max
    #else
        let n = arc4random_uniform(UInt32(max))
    #endif
    return 1 + Int(n)
}
