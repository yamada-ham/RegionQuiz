import UIKit
import Foundation
import AVFoundation

class SoundController: NSObject {
    var soundData = NSDataAsset(name: "yume")!.data
    var soundDataGame = NSDataAsset(name: "natsuyasuminotanken")!.data
    var soundDataBtn = NSDataAsset(name: "btn")!.data
    var soundPlayer: AVAudioPlayer?
    var soundPlayerGame: AVAudioPlayer?
    var soundPlayerBtn: AVAudioPlayer?
    
    func soundPlay() {
        do {
            soundPlayer = try AVAudioPlayer(data: soundData)
            soundPlayer?.play()
        } catch let error {
            print("音楽で、エラーが発生しました！: \(error.localizedDescription)")
        }
    }
    
    func soundPlayGame() {
        do {
            soundPlayerGame = try AVAudioPlayer(data: soundDataGame)
            soundPlayerGame?.play()
        } catch let error {
            print("音楽で、エラーが発生しました！: \(error.localizedDescription)")
        }
    }
    
    func soundPlayBtn() {
        do {
            soundPlayerBtn = try AVAudioPlayer(data: soundDataBtn)
            soundPlayerBtn?.play()
        } catch let error {
            print("音楽で、エラーが発生しました！: \(error.localizedDescription)")
        }
    }
    
    func soundStop() {
        if let soundPlayer = soundPlayer {
            soundPlayer.stop()
            self.soundPlayer = nil
        }
    }
    
    func soundStopGame() {
        if let soundPlayerGame = soundPlayerGame {
            soundPlayerGame.stop()
            self.soundPlayerGame = nil
        }
    }
    
    func soundStopBtn() {
        if let soundPlayerBtn = soundPlayerBtn {
            soundPlayerBtn.stop()
            self.soundPlayerBtn = nil
        }
    }
}

