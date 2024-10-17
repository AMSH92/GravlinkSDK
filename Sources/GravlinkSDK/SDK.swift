// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import PushKit
import UserNotifications

public struct Gravlink {
    private static var isAPIKeyValid = false
    private static let networkManager = NetworkManager.shared
    private static let socketManager = SocketIOManager()
    private static let callManager = CallManager.shared

    private static func checkAPIKey() -> Bool {
        if !isAPIKeyValid {
            Logger.log("Please Set ApiKey", level: .error)
        }
        return isAPIKeyValid
    }
    

    public static func configure(apiKey: String) {
        let request = ConfigureRequest(apiKey: apiKey)
        let endPoint = ClientEndPoint.configure(request: request)
        
        self.networkManager.request(endPoint) { (result: Result<EmptyApiModel, Error>) in
            switch result {
            case .success(_):
                Logger.log("Gravlink Configured successfuly", level: .info)
                self.callManager.setSocketManager(socket: self.socketManager)
                break
            case .failure(let failure):
                Logger.log("Error configuring api key: \(failure.localizedDescription)", level: .error)
            }
        }
    }
    
    public static func setUser(user: GLinkUser) {
        guard checkAPIKey() else {return }
        
        self.networkManager.setUser(user: user) { results in
            switch results {
            case .success(_):
                Logger.log("successfuly set user with:  \(user)", level: .info)
            case .failure(let failure):
                Logger.log("Error setting user: \(failure.localizedDescription)", level: .error)
            }
        }
    }
    
    public static func setFCMNotificationToken(token: GLinkToken) {
        guard checkAPIKey() else {return}
        
        let endPoint = ClientUserEndPoint.setPCMNotificationToken(token: token)
        self.networkManager.request(endPoint) { (result: Result<EmptyApiModel, Error>) in
            switch result {
            case .success(_):
                Logger.log("successfuly set fcm token with:  \(token.token)", level: .info)
                break
            case .failure(let failure):
                Logger.log("Error setting token: \(failure.localizedDescription)", level: .error)
                break
            }
        }
    }
    
    private static func setVOIPNotificationToken(token: GLinkToken) {
        guard checkAPIKey() else {return}
        
        let endPoint = ClientUserEndPoint.setPCMNotificationToken(token: token)
        self.networkManager.request(endPoint) { (result: Result<EmptyApiModel, Error>) in
            switch result {
            case .success(_):
                Logger.log("successfuly set voip token with:  \(token.token)", level: .info)
                break
            case .failure(let failure):
                Logger.log("Error setting token: \(failure.localizedDescription)", level: .error)

            }
        }
    }
    
    public static func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  didReceive response: UNNotificationResponse,
                                              withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let callId = userInfo["callId"] as? String,
           let offer = userInfo["offer"] as? String {
            print("User tapped on notification with callId: \(callId)")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 , execute: {
                self.socketManager.acceptCall(callId: callId, offer: offer, iceservers: [])
            })
            
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [callId])
        }
        
        completionHandler()
    }

    public static func gLinkPushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        let token = pushCredentials.token.map { String(format: "%02x", $0) }.joined()
        Logger.log("PushKit Token: \(token)", level: .info)
        self.setVOIPNotificationToken(token: GLinkToken(token: token, type: .voip))
    }
    
    public static func gLinkPushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        guard type == .voIP else { return }
        guard let callId = payload.dictionaryPayload["callId"] as? String else {return}
        guard let offer = payload.dictionaryPayload["offer"] as? String else {return}
        guard let handler = payload.dictionaryPayload["handler"] as? String else {return}
        self.callManager.reportIncomingCall(handler: handler, callId: callId, offer: offer)
        completion()
    }
}
