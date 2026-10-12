@testable import EversenseKit
import Foundation
import Testing

struct AuthWhoAmIPacketTests {
    @Test func parsesTxFlagsBitWhenPresent() {
        var data = Data(repeating: 0, count: 44)
        data[42] = 0x10

        let response = Eversense365.AuthWhoAmIPacket(secret: Data()).parseResponse(data: data)

        #expect(response.flags)
    }

    @Test func parsesTxFlagsBitWhenAbsent() {
        var data = Data(repeating: 0, count: 44)
        data[42] = 0x01

        let response = Eversense365.AuthWhoAmIPacket(secret: Data()).parseResponse(data: data)

        #expect(!response.flags)
    }
}