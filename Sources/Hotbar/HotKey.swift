import AppKit
import Carbon.HIToolbox

enum HotKey {
    private static var refs: [EventHotKeyRef?] = []
    private static var handlers: [UInt32: () -> Void] = [:]

    static func register(keyCode: Int, action: @escaping () -> Void) {
        if handlers.isEmpty {
            var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
            InstallEventHandler(GetApplicationEventTarget(), { _, event, _ in
                var id = EventHotKeyID()
                GetEventParameter(event, EventParamName(kEventParamDirectObject), EventParamType(typeEventHotKeyID),
                                  nil, MemoryLayout<EventHotKeyID>.size, nil, &id)
                DispatchQueue.main.async { HotKey.handlers[id.id]?() }
                return noErr
            }, 1, &eventType, nil, nil)
        }
        let id = UInt32(handlers.count + 1)
        handlers[id] = action
        var ref: EventHotKeyRef?
        RegisterEventHotKey(UInt32(keyCode), 0, EventHotKeyID(signature: OSType(0x48544252), id: id), GetApplicationEventTarget(), 0, &ref)
        refs.append(ref)
    }
}
