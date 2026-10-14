import Foundation

enum Handy {
    static func restart() {
        let kill = Process()
        kill.executableURL = URL(fileURLWithPath: "/usr/bin/pkill")
        kill.arguments = ["-9", "-x", "handy"]
        try? kill.run()
        kill.waitUntilExit()
        let open = Process()
        open.executableURL = URL(fileURLWithPath: "/usr/bin/open")
        open.arguments = ["-a", "Handy"]
        try? open.run()
    }
}
