//
//  LongDrageViewController.swift
//  More
//
//  Created by Modi on 2019/6/13.
//  Copyright © 2019年 modi. All rights reserved.
//

import UIKit
import ObjectMapper
import AudioUnit
import AVFoundation
import DOUAudioStreamer

class LongDrageViewController: UIViewController {

    @IBOutlet weak var longdrageMaxValue: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView! {
        didSet {
            indicator.color = UIColor.init(red: 35/255, green: 173/255, blue: 229/255, alpha: 1.0)
        }
    }
    
    //表示当前是否在播放
    var isPlaying = false
    
    var type = 0 // 0: 赛车 1: 飞艇
    
    var offsetTime = 120 // 默认两分钟监听一次
    
    var end = false
    
    var number = 0
    
    var streamer: DOUAudioStreamer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        longdrageMaxValue.becomeFirstResponder()
        // 开启轮询
        end = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        longdrageMaxValue.resignFirstResponder()
        // 结束轮询
        end = true
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startListening(_ sender: UIButton) {
        
        longdrageMaxValue.resignFirstResponder()
        
        if let text = longdrageMaxValue.text, text != "" {
            let number = Int(text) ?? 0
            
            self.number = number
            
            Thread.detachNewThread {
                self.startRunLoop()
            }
        }else {
            print("请输入长龙临界值")
            SVProgressHUD.showInfo(withStatus: "请输入长龙临界值")
            return
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            self.perform(#selector(self.updateStatus), on: .main, with: nil, waitUntilDone: false)
        }
    }
    
    @objc private func updateStatus() {
        if streamer.status != .playing {
            streamer.play()
        }
    }
    
    func handlerResult() {
        
        // 无限播放MP3
//        guard let url = URL(string: "http://cache.musicz.co/music/mp3/53863054034879819065867733833771.mp3") else {
//            SVProgressHUD.showInfo(withStatus: "mp3文件不存在")
//            return
//        }
//        let player = AVPlayer(url: url)
//        player.allowsExternalPlayback = true
//
//        if player.timeControlStatus != .playing {
//            player.play()
//        }
        
        
        if let streamer = DOUAudioStreamer.init(audioFile: TempMP3Model()) {
            self.streamer = streamer
            streamer.addObserver(self, forKeyPath: "status", options: .new, context: nil)
            streamer.play()
        }
        
        // 添加通知循环播放
//        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { (notification) in
//            player.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
//            player.play()
//        }
        
        getDatas { (ldModel) in
            if let dragonModels = ldModel.data_result?.data_data {
                for item in dragonModels {
                    let count = item.data_count
                    if count > self.number {
                        // 报警
                        //建立的SystemSoundID对象
                        //                            let soundID = SystemSoundID(kSystemSoundID_Vibrate)
                        //振动
                        //                            AudioServicesPlaySystemSound(soundID)
                        
                        if !self.isPlaying {
                            
                            //建立的SystemSoundID对象
                            var soundID:SystemSoundID = SystemSoundID(kSystemSoundID_Vibrate)
                            //获取声音地址
                            let path = Bundle.main.path(forResource: "redpackge_sound", ofType: "mp3")
                            //地址转换
                            let baseURL = NSURL(fileURLWithPath: path!)
                            //赋值
                            AudioServicesCreateSystemSoundID(baseURL, &soundID)
                            
                            //添加音频结束时的回调
                            let observer = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
                            AudioServicesAddSystemSoundCompletion(soundID, nil, nil, {
                                (soundID, inClientData) -> Void in
                                let mySelf = Unmanaged<LongDrageViewController>.fromOpaque(inClientData!)
                                    .takeUnretainedValue()
                                mySelf.audioServicesPlaySystemSoundCompleted(soundID: soundID)
                            }, observer)
                            
                            //播放声音
                            AudioServicesPlaySystemSound(soundID)
                            self.isPlaying = true
                        }
                    }
                }
            }
        }
        
    }
    
    //音频结束时的回调
    func audioServicesPlaySystemSoundCompleted(soundID: SystemSoundID) {
        print("Completion")
        isPlaying = false
        AudioServicesRemoveSystemSoundCompletion(soundID)
        AudioServicesDisposeSystemSoundID(soundID)
    }
    
    // MARK: - 轮询监控
    func getDatas(finished: ((_ model: LongDragonModel)->Void)?) {
        var lotCode = "10001" // 默认赛车
        if type == 1 {
            lotCode = "10057"
        }
        let urls = "https://api.api861861.com/pks/getPksLongDragonCount.do?date=&lotCode=" + lotCode
        let config = URLSessionConfiguration.default
        let us = URLSession(configuration: config)
        guard let url = URL(string: urls) else {
            return
        }
        let task = us.dataTask(with: url) { (data, response, error) in
            if let d = data {            
                let jsonStr = String.init(data: d, encoding: String.Encoding.utf8) ?? ""
//                let json = try! JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableLeaves)
                if let ldModel = Mapper<LongDragonModel>().map(JSONString: jsonStr) {
                    if let b = finished {
                        b(ldModel)
                    }
                }
            }
        }
        task.resume()
    }
    
}

// MARK: - 轮询
extension LongDrageViewController {
    func startRunLoop() {
        end = false
        let runLoop = RunLoop.current
        let timer = Timer(timeInterval: 10, repeats: true) { (timer) in
            print("定时任务轮询中···")
            DispatchQueue.main.async {
                self.indicator.startAnimating()
                
                self.handlerResult()
            }
        }
        runLoop.add(timer, forMode: RunLoop.Mode.default)
        while !end {
            runLoop.run(until: Date.init(timeIntervalSinceNow: 3.0))
        }
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
        }
    }
}

class TempMP3Model: NSObject, DOUAudioFile {
    func audioFileURL() -> URL! {
        if let path = Bundle.main.path(forResource: "silent.mp3", ofType: nil) {
            let url = URL(fileURLWithPath: path)
            return url
        }
        return URL(string: "http://cache.musicz.co/music/mp3/53863054034879819065867733833771.mp3")
    }
}

