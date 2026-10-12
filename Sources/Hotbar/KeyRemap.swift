import Foundation
import IOKit

enum KeyRemap {
    private static var port: IONotificationPortRef?
    private static var iterator: io_iterator_t = 0

    static func start() {
        port = IONotificationPortCreate(kIOMainPortDefault)
        CFRunLoopAddSource(CFRunLoopGetMain(), IONotificationPortGetRunLoopSource(port).takeUnretainedValue(), .defaultMode)
        let matching = IOServiceMatching("IOHIDEventService") as NSMutableDictionary
        matching["PrimaryUsagePage"] = 1
        matching["PrimaryUsage"] = 6
        IOServiceAddMatchingNotification(port, kIOFirstMatchNotification, matching, { _, iterator in
            KeyRemap.drain(iterator)
            KeyRemap.apply()
        }, nil, &iterator)
        drain(iterator)
        apply()
    }

    private static func drain(_ iterator: io_iterator_t) {
        while case let service = IOIteratorNext(iterator), service != 0 {
            IOObjectRelease(service)
        }
    }

    // F14 dims the screen on Apple keyboards; F20 does nothing.
    private static func apply() {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/hidutil")
        process.arguments = [
            "property", "--matching", #"{"PrimaryUsagePage":1,"PrimaryUsage":6}"#,
            "--set", #"{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000069,"HIDKeyboardModifierMappingDst":0x70000006F}]}"#,
        ]
        process.standardOutput = FileHandle.nullDevice
        try? process.run()
    }
}
