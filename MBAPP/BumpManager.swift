import CoreNFC
import UIKit

class BumpManager: NSObject, NFCTagReaderSessionDelegate {
    var session: NFCTagReaderSession?

    func beginSession() {
        guard NFCNDEFReaderSession.readingAvailable else {
            print("NFC is not available on this device")
            return
        }

        session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        session?.alertMessage = "Hold your iPhone near another iPhone to exchange contact information."
        session?.begin()
    }

    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("Session became active")
    }

    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print("Session invalidated: \(error.localizedDescription)")
    }

    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        if tags.count > 1 {
            session.alertMessage = "More than one tag detected. Please try again."
            session.invalidate()
            return
        }

        guard let tag = tags.first else {
            session.invalidate()
            return
        }

        session.connect(to: tag) { error in
            if let error = error {
                session.alertMessage = "Unable to connect to tag: \(error.localizedDescription)"
                session.invalidate()
                return
            }

            if case let .miFare(sTag) = tag {
                let identifier = sTag.identifier
                // Here you can write the logic to exchange the user information using the identifier
                session.alertMessage = "Successfully connected to tag."
                session.invalidate()
            }
        }
    }
}
