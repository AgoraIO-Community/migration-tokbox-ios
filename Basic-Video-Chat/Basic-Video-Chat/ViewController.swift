//
//  ViewController.swift
//  Hello-World
//
//  Created by Roberto Perez Cubero on 11/08/16.
//  Copyright © 2016 tokbox. All rights reserved.
//

import UIKit
import AgoraRtcKit

// *** Fill the following variables using your own Project info  ***
// ***            https://tokbox.com/account/#/                  ***
// Replace with your OpenTok API key
let AppID = ""
// Replace with your generated session ID
let kSessionId = ""
// Replace with your generated token
let kToken = ""

let kWidgetHeight = 240
let kWidgetWidth = 320

class ViewController: UIViewController {
    var agoraKit: AgoraRtcEngineKit!
    
    @IBOutlet weak var stackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeAgoraEngine()
        setupLocalVideo(uid: 0)
        joinChannel()
    }
    
    func initializeAgoraEngine() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: AppID, delegate: self)
    }
    
    func setupLocalVideo(uid: UInt) {
        
        let videoView = UIView()
        videoView.tag = Int(uid)
        videoView.backgroundColor = UIColor.orange
        
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = videoView
        videoCanvas.renderMode = .hidden
        agoraKit.setupLocalVideo(videoCanvas)
        
        stackView.addArrangedSubview(videoView)
        
    }

    
    func joinChannel() {
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        
        agoraKit.joinChannel(byToken: nil, channelId: "demoChannel1", info:nil, uid:0){[weak self] (sid, uid, elapsed) -> Void in
            // Join channel “demoChannel1”
        }
        UIApplication.shared.isIdleTimerDisabled = true
    }

}

extension ViewController: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        let videoView = UIView()
        videoView.tag = Int(uid)
        videoView.backgroundColor = UIColor.purple
        
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = videoView
        videoCanvas.renderMode = .hidden
        agoraKit.setupRemoteVideo(videoCanvas)

        stackView.addArrangedSubview(videoView)

    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        guard let view = stackView.arrangedSubviews.first(where: { (view) -> Bool in
            return view.tag == Int(uid)
        }) else { return }
        
        stackView.removeArrangedSubview(view)

    }
}

//// MARK: - OTSession delegate callbacks
//extension ViewController: OTSessionDelegate {
//    func sessionDidConnect(_ session: OTSession) {
//        print("Session connected")
//        doPublish()
//    }
//
//    func sessionDidDisconnect(_ session: OTSession) {
//        print("Session disconnected")
//    }
//
//    func session(_ session: OTSession, streamCreated stream: OTStream) {
//        print("Session streamCreated: \(stream.streamId)")
//        if subscriber == nil {
//            doSubscribe(stream)
//        }
//    }
//
//    func session(_ session: OTSession, streamDestroyed stream: OTStream) {
//        print("Session streamDestroyed: \(stream.streamId)")
//        if let subStream = subscriber?.stream, subStream.streamId == stream.streamId {
//            cleanupSubscriber()
//        }
//    }
//
//    func session(_ session: OTSession, didFailWithError error: OTError) {
//        print("session Failed to connect: \(error.localizedDescription)")
//    }
//
//}
//
//// MARK: - OTPublisher delegate callbacks
//extension ViewController: OTPublisherDelegate {
//    func publisher(_ publisher: OTPublisherKit, streamCreated stream: OTStream) {
//        print("Publishing")
//    }
//
//    func publisher(_ publisher: OTPublisherKit, streamDestroyed stream: OTStream) {
//        cleanupPublisher()
//        if let subStream = subscriber?.stream, subStream.streamId == stream.streamId {
//            cleanupSubscriber()
//        }
//    }
//
//    func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
//        print("Publisher failed: \(error.localizedDescription)")
//    }
//}
//
//// MARK: - OTSubscriber delegate callbacks
//extension ViewController: OTSubscriberDelegate {
//    func subscriberDidConnect(toStream subscriberKit: OTSubscriberKit) {
//        if let subsView = subscriber?.view {
//            subsView.frame = CGRect(x: 0, y: kWidgetHeight, width: kWidgetWidth, height: kWidgetHeight)
//            view.addSubview(subsView)
//        }
//    }
//
//    func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
//        print("Subscriber failed: \(error.localizedDescription)")
//    }
//}
