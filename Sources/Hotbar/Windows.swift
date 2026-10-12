import AppKit
import ApplicationServices

@_silgen_name("_AXUIElementGetWindow")
func _AXUIElementGetWindow(_ element: AXUIElement, _ windowID: UnsafeMutablePointer<CGWindowID>) -> AXError

enum Windows {
    static func requestAccess() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
        AXIsProcessTrustedWithOptions(options)
    }

    static func cycleFrontApp() {
        guard let app = NSWorkspace.shared.frontmostApplication else { return }
        let pid = app.processIdentifier
        DispatchQueue.global(qos: .userInteractive).async {
            let windows = visibleWindows(pid: pid)
            guard windows.count > 1, let next = windows.last else { return }
            AXUIElementPerformAction(next, kAXRaiseAction as CFString)
            DispatchQueue.main.async { app.activate() }
        }
    }

    private static func visibleWindows(pid: pid_t) -> [AXUIElement] {
        let axApp = AXUIElementCreateApplication(pid)
        AXUIElementSetMessagingTimeout(axApp, 1.0)
        var windowsRef: CFTypeRef?
        guard AXUIElementCopyAttributeValue(axApp, kAXWindowsAttribute as CFString, &windowsRef) == .success,
              let axWindows = windowsRef as? [AXUIElement] else { return [] }
        let zOrder = zOrderMap()
        let onScreen = axWindows.compactMap { ax -> (AXUIElement, Int)? in
            var id: CGWindowID = 0
            guard _AXUIElementGetWindow(ax, &id) == .success, let z = zOrder[id] else { return nil }
            var minimized: CFTypeRef?
            AXUIElementCopyAttributeValue(ax, kAXMinimizedAttribute as CFString, &minimized)
            guard (minimized as? Bool) != true else { return nil }
            return (ax, z)
        }
        return onScreen.sorted { $0.1 < $1.1 }.map(\.0)
    }

    private static func zOrderMap() -> [CGWindowID: Int] {
        guard let list = CGWindowListCopyWindowInfo([.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID) as? [[String: Any]] else {
            return [:]
        }
        var order: [CGWindowID: Int] = [:]
        for (index, info) in list.enumerated() {
            guard let layer = info[kCGWindowLayer as String] as? Int, layer == 0,
                  let id = info[kCGWindowNumber as String] as? CGWindowID else { continue }
            order[id] = index
        }
        return order
    }
}
