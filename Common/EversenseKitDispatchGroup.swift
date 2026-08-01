final class EversenseKitDispatchGroup {
    private let group = DispatchGroup()
    private let lock = NSLock()
    private var count = 0

    func enter() {
        lock.lock()
        count += 1
        lock.unlock()
        group.enter()
    }

    func leave() {
        lock.lock()
        defer { lock.unlock() }

        guard count > 0 else {
            // Disconnect cleanup and a response/timeout path can race. Treat
            // extra leaves as no-ops; leaving the lock held here deadlocks the
            // next command and can strand the underlying dispatch object.
            return
        }

        count -= 1
        group.leave()
    }

    @discardableResult func wait(timeout: DispatchTime) -> DispatchTimeoutResult {
        group.wait(timeout: timeout)
    }
}
