@testable import EversenseKit
import Dispatch
import Testing

struct DispatchGroupLifecycleTests {
    @Test func extraLeaveDoesNotPoisonFutureUse() throws {
        let group = EversenseKitDispatchGroup()
        group.enter()
        group.leave()

        // Disconnect cleanup can race with a response/timeout path and call leave more
        // than once. Extra leaves must be ignored without leaving the lock held.
        group.leave()

        let completed = DispatchSemaphore(value: 0)
        DispatchQueue.global(qos: .userInitiated).async {
            group.enter()
            group.leave()
            completed.signal()
        }

        #expect(completed.wait(timeout: .now() + .seconds(1)) == .success)
    }
}
