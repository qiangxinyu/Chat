//
//  AudioManager.swift
//  GPSwfitObject
//
//  Created by 强新宇 on 2017/11/20.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import UIKit
import EZAudio

fileprivate let url = documentPath + "/Voice"
fileprivate let filePath = url + "/manager.data"
fileprivate let ffilePath = "file://" + filePath

class AudioManager: NSObject, EZMicrophoneDelegate, EZAudioPlayerDelegate, EZRecorderDelegate {
    
    static let Default = AudioManager()
    
    var recorder: EZRecorder?
    var player = EZAudioPlayer()
    var microphone = EZMicrophone()
    
    var outDevice = EZAudioDevice.init()
    
  
    
    private override init() {
        super.init()
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        } catch  {
            print("audio session error -> \(error)")
        }
        
        do {
            try session.setActive(true)
        } catch {
            print("audio session active -> \(error)")
        }
        
        microphone.delegate = self
        player.delegate = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(proximityStateChange), name: Notification.Name.UIDeviceProximityStateDidChange, object:  nil)
        
    }
    
    @objc func proximityStateChange() {
        let session = AVAudioSession.sharedInstance()
        do {
            if UIDevice.current.proximityState {
                try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            } else {
                try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            }
        } catch {
            print("audio session overrideOutputAudioPort -> \(error)")
        }
        
    }
    

    class func setAudioURL(url: String, audioURL: String)  {
        let file = FileManager.default
        if !file.fileExists(atPath: filePath) {
            do {
                let dic = [String : String]()
                let data = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
                file.createFile(atPath: filePath, contents: data, attributes: nil)
            } catch {}
        }
        
        if let fileURL = URL.init(string: ffilePath) {
            do {
                let data = try Data.init(contentsOf: fileURL)
                if var dic = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : String] {
                    dic[url] = audioURL
                    let newData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
                    try newData.write(to: fileURL)
                }
            } catch {
                print("aaaa ",error)
            }
        }
    }
    
    class func getAudioURL(url: String) -> String? {
        if let fileURL = URL.init(string: ffilePath) {
            do {
                let data = try Data.init(contentsOf: fileURL)
                if var dic = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : String] {
                    return dic[url]
                }
            } catch {}
        }
        return nil
    }
    class func clearFile()  {
        let file = FileManager.default
        do {
            try file.removeItem(atPath: url)
        } catch {
            print(error)
        }
    }
    
    
    // MARK: - Player
    func play(file: EZAudioFile?)  {
        microphone.stopFetchingAudio()
        recorder?.closeAudioFile()
        
        player.playAudioFile(file)
        
        UIDevice.current.isProximityMonitoringEnabled = true

    }
    
    class func play(file: EZAudioFile?)  {
        Default.play(file: file)
    }
    
    class func stop() {
        Default.player.pause()
        
        UIDevice.current.isProximityMonitoringEnabled = false
    }
    
    func createAudioFile(url:URL?) -> EZAudioFile? {
        if let url = url {
            do {
                _ = try Data.init(contentsOf: url)
                return EZAudioFile.init(url: url)
            } catch {}
        }
        return nil
    }
    class func createAudioFile(url:URL?) -> EZAudioFile? {
        return Default.createAudioFile(url: url)
    }
    
    // MARK: - Recorder
    class func recorderCancel()  {
        if let url = Default.recorderStop() {
            let manager = FileManager()
            do { try  manager.removeItem(at: url) } catch _ {}
        } 
    }
    
    class func recorderStop() -> URL? {
        return Default.recorderStop()
    }
    func recorderStop() -> URL?  {
        microphone.stopFetchingAudio()
        recorder?.closeAudioFile()
        if let url = fileURL {
            if let file = createAudioFile(url: url) {
                if file.duration < 1.0 {
                    return nil
                }
            }
        }
        return fileURL!
    }
    
    class func recorderStart()  {
        Default.recorderStart()
    }
    func recorderStart()  {
        AudioManager.stop()
        recorder?.delegate = nil
        recorder = nil
        
        microphone.startFetchingAudio()
        
        if let url = filePathURL() {
            fileURL = url
            recorder = EZRecorder.init(url: url, clientFormat: microphone.audioStreamBasicDescription(), fileType: EZRecorderFileType.M4A, delegate: self)
        }
    }
    
    // MARK: - Microphone Method
    class func microphoneStart() {
        Default.microphoneStart()
    }
    
    class func microphoneStop() {
        Default.microphoneStop()
    }
    
    func microphoneStart() {
        microphone.startFetchingAudio()
    }
    
    func microphoneStop() {
        microphone.stopFetchingAudio()
    }
    
    
    // MARK: - Microphone Delegate
    func microphone(_ microphone: EZMicrophone!, hasBufferList bufferList: UnsafeMutablePointer<AudioBufferList>!, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        recorder?.appendData(from: bufferList, withBufferSize: bufferSize)
    }
    
    func microphone(_ microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>?>!, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        
        var meanVal = Float()
        var one: Float = 1.0
        var two: Float = 0.1
        
        vDSP_vsq(buffer[0]!, 1, buffer[0]!, 1, vDSP_Length(bufferSize))
        vDSP_meanv(buffer[0]!, 1, &meanVal,vDSP_Length(bufferSize))
        vDSP_vdbcon(&meanVal, 1, &one, &two, 1, 1, 0)
        
        two += 60
        
        
        dbHandle?(two)
    }
    
    func getDB(dbHandle: @escaping (Float) -> Void ) {
        self.dbHandle = dbHandle
    }
    var dbHandle: ((Float) -> Void)?
    var fileURL: URL?
    
    // MARK: - File Method
    func filePathURL() -> URL? {
        let file = FileManager.default
        if !file.fileExists(atPath: url) {
            do {
                try file.createDirectory(atPath: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("create file directory error \(error)")
            }
        }
        return URL.init(fileURLWithPath: "\(url)/\(Date().timeIntervalSince1970).m4a")
    }
    
    class func filePathURL() -> URL? {
        return Default.filePathURL()
    }
}
