import Foundation

public class LineEmitter: NSObject, NSStreamDelegate {

    var endFunc: (() -> ())?

    private let stream: NSInputStream
    private let lineFunc: (String) -> ()
    private var buffer = ""

    init(stream: NSInputStream, lineFunc: (String) -> ()) {
        self.stream = stream
        self.lineFunc = lineFunc
        super.init()
        openStream()
    }

    convenience init?(path: String, lineFunc: (String) -> ()) {
        guard let stream = NSInputStream(fileAtPath: path) else {
            return nil
        }
        self.init(stream: stream, lineFunc: lineFunc)
    }

    private func openStream() {
        stream.delegate = self
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            self.stream.scheduleInRunLoop(.currentRunLoop(), forMode: NSDefaultRunLoopMode)
            self.stream.open()
            NSRunLoop.currentRunLoop().run()
        }
    }

    private func closeStream() {
        stream.delegate = nil
        stream.close()
        stream.removeFromRunLoop(.currentRunLoop(), forMode: NSDefaultRunLoopMode)
    }

    // MARK: NSStreamDelegate methods

    public func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        switch (eventCode) {
        case NSStreamEvent.HasBytesAvailable:
            bufferFromStream()

        case NSStreamEvent.EndEncountered:
            checkForLastLine()
            closeStream()

        case NSStreamEvent.ErrorOccurred:
            print("stream error: \(stream.streamError)")
            checkForLastLine()
            closeStream()

        default: break
        }
    }

    private func bufferFromStream() {
        if stream.hasBytesAvailable {
            let size = 16_384
            var bytes = [UInt8](count: size, repeatedValue: 0)
            let bytesRead = stream.read(&bytes, maxLength: size)
            bytes.removeRange(Range(start: bytesRead, end: size))
            guard let string = String(bytes: bytes, encoding: NSUTF8StringEncoding) else {
                print("failed to create string from bytes")
                return
            }
            buffer += string
            checkForLines()
        }
        if stream.streamStatus == .AtEnd {
            checkForLastLine()
            closeStream()
        }
    }

    private func checkForLines() {
        while let range = buffer.rangeOfString("\n") {
            let line = buffer.substringToIndex(range.endIndex)
            buffer = buffer.substringFromIndex(range.endIndex)
            lineFunc(line)
        }
    }

    private func checkForLastLine() {
        if buffer.characters.count > 0 {
            lineFunc(buffer)
            buffer = ""
        }
        if let f = endFunc {
            f()
            endFunc = nil
        }
    }

}
