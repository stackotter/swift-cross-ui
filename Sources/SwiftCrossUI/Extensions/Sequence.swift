#if swift(<6.0)
    extension Sequence {
        /// Back-ported implementation of `count(where:)` for pre Swift 6.
        func count(where predicate: (Element) -> Bool) -> Int {
            var count = 0
            for element in self where predicate(element) {
                count += 1
            }
            return count
        }
    }
#endif
