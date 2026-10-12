import Foundation

enum Power {
    static func run(_ command: String) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/pmset")
        process.arguments = [command]
        try? process.run()
    }
}
