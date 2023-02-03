import Foundation
import WatchConnectivity

final class WatchCommunicationManager: NSObject, ObservableObject {
    @Published var text: String?
    
    private let session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        self.session.activate()
        self.text =  "0"
    }
    
    func updateText(_ text: String) {
        session.sendMessage(["method": "updateFromWatch", "data": ["text": text]], replyHandler: nil, errorHandler: nil)
        
        var counter = Int(self.text ?? "") ?? 0;
        
        if(text == "increment"){
            
            counter += 1;
        }
        else {
            counter = (counter > 0 ) ? counter - 1 : 0;
        }
        self.text = String(counter);
    }
}

extension WatchCommunicationManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard let method = message["method"] as? String, let data = message["data"] as? [String: Any] else { return }
        
        guard method == "updateFromApp", let text = data["text"] as? String else { return }
       
        Task { @MainActor in
            self.text = text
        }
    }
}
