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
import SelectionList
import SVProgressHUD

private struct Constant {
    static let enableColor = UIColor.init(red: 35/255, green: 173/255, blue: 229/255, alpha: 1.0)
    static let disEnableColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1.0)
    static let identifier = "Cell"
    static let PK10Tag = "赛车🏁："
    static let ShipTag = "飞艇🏁："
}

class LongDrageViewController: UIViewController {
    
    @IBOutlet weak var timeOffsetValue: UITextField!
    @IBOutlet weak var doubleMaxValue: UITextField!
    @IBOutlet weak var longdrageMaxValue: UITextField!
    @IBOutlet weak var resultValue: UILabel!
    @IBOutlet weak var startListening: UIButton!
    @IBOutlet weak var stopListening: UIButton!
    
    @IBOutlet var selectionList: SelectionList!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.layer.cornerRadius = 5
            tableView.layer.masksToBounds = true
            tableView.tableFooterView = UIView()
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constant.identifier)
        }
    }
    var datas = [String]()
    
    @IBOutlet var labels: [UILabel]! {
        didSet {
            for item in labels {
                item.layer.cornerRadius = 5
                item.layer.masksToBounds = true
            }
        }
    }
    @IBOutlet weak var isVibration: UISwitch!
    
    //表示当前是否在播放
    var isPlaying = false
    
    // 0: 赛车 1: 飞艇
    var type = 0 {
        didSet {
            if type == 0 {
                offsetTime = 6 * 60
            }else {
                offsetTime = Int(1.5 * 60)
            }
        }
    }
    var level = -1
    
    var offsetTime = 120 // 默认两分钟监听一次
    
    var vibrationTime = 5 // 默认振动10s
    
    var playSoundId: SystemSoundID!
    
    var end = false
    
    /// 长龙临界值
    var number = 0
    
    /// 双面临界值
    var doubleNumber = 0
    
    var streamer: DOUAudioStreamer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectionList.items = ["北京PK10", "幸运飞艇"]
//        selectionList.selectedIndexes = [0, 1]
        selectionList.addTarget(self, action: #selector(selectionChanged), for: .valueChanged)
        selectionList.setupCell = { (cell: UITableViewCell, _: Int) in
            cell.textLabel?.textColor = .gray
        }
    }
    
    @objc func selectionChanged() {
        print(selectionList.selectedIndexes)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.doubleMaxValue.becomeFirstResponder()
        // 开启轮询
        end = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timeOffsetValue.resignFirstResponder()
        doubleMaxValue.resignFirstResponder()
        longdrageMaxValue.resignFirstResponder()
        // 结束轮询
        end = true
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func stopListening(_ sender: UIButton) {
        
        stopListening.isEnabled = false
        startListening.isEnabled = true
        stopListening.backgroundColor = Constant.disEnableColor
        startListening.backgroundColor = Constant.enableColor
        
        // 清空列表
        self.datas.removeAll()
        self.tableView.reloadData()
        
        self.end = true
        SVProgressHUD.dismiss()
        
//        streamer.pause()
    }
    
    @IBAction func startListening(_ sender: UIButton) {
        
        //时间赋值
        self.offsetTime = Int(timeOffsetValue.text ?? "0") ?? 0
        
        doubleMaxValue.resignFirstResponder()
        longdrageMaxValue.resignFirstResponder()
        
        if selectionList.selectedIndexes.count == 0 {
            SVProgressHUD.showInfo(withStatus: "请选择要监控的彩票")
            return
        }
        
        if let text = longdrageMaxValue.text, text != "", let dtext = doubleMaxValue.text, dtext != "" {
            
            startListening.isEnabled = false
            stopListening.isEnabled = true
            startListening.backgroundColor = Constant.disEnableColor
            stopListening.backgroundColor = Constant.enableColor
            
            self.playSilentMusic()
            
            let number = Int(text) ?? 0
            let doubleNumber: Int = Int(dtext) ?? 0
            
            self.number = number
            
            self.doubleNumber = doubleNumber
            
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
        if streamer.status == .finished || streamer.status == .error {
            self.resetStreamer()
        }
    }
    
    private func cancelStreamer() {
        if streamer != nil {
            streamer.pause()
            streamer.removeObserver(self, forKeyPath: "status")
            streamer = nil
        }
    }
    
    private func resetStreamer() {
        self.cancelStreamer()
        // 为空时会奔溃
        // music.audioFileURL()
        streamer = DOUAudioStreamer(audioFile: Mp3Model())
        streamer.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        streamer.volume = 0
        streamer.play()
    }
    
    func handlerResult() {
        
        if selectionList.selectedIndexes.contains(0) {
            let lotCode = "10001"
            ModelTools.analysisLongDragon(lotCode: lotCode, number: number, doubleNumber: doubleNumber) {(text, level) in
                DispatchQueue.main.async {
                    self.reloadDatas(text: text, type: 0)
                }
            }
        }
        if selectionList.selectedIndexes.contains(1) {
            let lotCode = "10057"
            ModelTools.analysisLongDragon(lotCode: lotCode, number: number, doubleNumber: doubleNumber) {(text, level) in
                DispatchQueue.main.async {
                    self.reloadDatas(text: text, type: 1)
                }
            }
        }
        
    }
    
    private func reloadDatas(text: String, type: Int) {
        
        var tempText = Constant.PK10Tag + text
        
        if type == 1 {
            tempText = Constant.ShipTag + text
        }else {
            tempText = Constant.PK10Tag + text
        }
        
        if self.datas.contains(tempText) {
//            let tempArr = NSMutableArray(array: self.datas)
//            tempArr.remove(tempText)
//            self.datas = tempArr as! [String]
            return
        }
        self.datas.append(tempText)
        self.tableView.reloadData()
        if isVibration.isOn {
            self.playVibration()
        }else {
            self.playAlarm()
        }
    }
    
    func playSilentMusic() {
        if let streamer = DOUAudioStreamer.init(audioFile: Mp3Model()) {
            self.streamer = streamer
            streamer.addObserver(self, forKeyPath: "status", options: .new, context: nil)
            streamer.volume = 0
            streamer.play()
        }
    }
    
    /// 播放警报音效
    func playAlarm() {
        streamer.pause()
        
        if !self.isPlaying {
            //建立的SystemSoundID对象
            var soundID:SystemSoundID = SystemSoundID(kSystemSoundID_Vibrate)
            
            //获取声音地址
            let path = Bundle.main.path(forResource: "media.io_66724", ofType: "wav")
            //                            let path = Bundle.main.path(forResource: "69153", ofType: "wav")
            //地址转换
            let baseURL = NSURL(fileURLWithPath: path!)
            //赋值
            AudioServicesCreateSystemSoundID(baseURL, &soundID)
            
            self.playSoundId = soundID
            
            //添加音频结束时的回调
            let observer = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
            AudioServicesAddSystemSoundCompletion(soundID, nil, nil, {
                (soundID, inClientData) -> Void in
                let mySelf = Unmanaged<LongDrageViewController>.fromOpaque(inClientData!)
                    .takeUnretainedValue()
//                mySelf.audioServicesPlaySystemSoundCompleted(soundID: soundID)
                mySelf.perform(#selector(self.playSound), with: nil, afterDelay: 1.0)
                
                mySelf.vibrationTime -=  1
                if mySelf.vibrationTime <= 0 {
                    mySelf.vibrationTime = 0
                }
                
            }, observer)
            
            //播放声音
            AudioServicesPlaySystemSound(soundID)
            
            // 暂停播放音乐
//            self.streamer.pause()
            // 播放音效并带震动
//            AudioServicesPlayAlertSound(soundID)
            
            self.isPlaying = true
        }
    }
    
    /// 振动
    func playVibration() {
        streamer.pause()
        
        if !self.isPlaying {
            //建立的SystemSoundID对象
            var soundID:SystemSoundID = SystemSoundID(kSystemSoundID_Vibrate)
            
            self.playSoundId = soundID
            
            //添加音频结束时的回调
            let observer = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
            AudioServicesAddSystemSoundCompletion(soundID, nil, nil, {
                (soundID, inClientData) -> Void in
                let mySelf = Unmanaged<LongDrageViewController>.fromOpaque(inClientData!)
                    .takeUnretainedValue()
                mySelf.perform(#selector(self.playSound), with: nil, afterDelay: 1.0)
                
                mySelf.vibrationTime -=  1
                if mySelf.vibrationTime <= 0 {
                    mySelf.vibrationTime = 0
                }
                
            }, observer)
            
            //播放声音
            AudioServicesPlaySystemSound(soundID)
            
            self.isPlaying = true
        }
    }
    
    @objc func playSound() {
        if vibrationTime != 0 {
            AudioServicesPlaySystemSound(playSoundId)
        }else {
            if isVibration.isOn {
                vibrationTime = 10
            }else {
                vibrationTime = 3
            }
            isPlaying = false
            AudioServicesRemoveSystemSoundCompletion(playSoundId)
            AudioServicesDisposeSystemSoundID(playSoundId)
            
            if streamer.status != .playing {
                streamer.play()
            }
        }
    }
    
    //音频结束时的回调
    func audioServicesPlaySystemSoundCompleted(soundID: SystemSoundID) {
        print("Completion")
        isPlaying = false
        AudioServicesRemoveSystemSoundCompletion(soundID)
        AudioServicesDisposeSystemSoundID(soundID)
        
        // 继续播放音乐
//        streamer.play()
    }
    
}

// MARK: - 轮询
extension LongDrageViewController {
    func startRunLoop() {
        end = false
        let runLoop = RunLoop.current
        let timer = Timer(timeInterval: TimeInterval(10), repeats: true) { (timer) in
            print("定时任务轮询中···")
            DispatchQueue.main.async {
//                self.indicator.startAnimating()
                SVProgressHUD.show()
                self.handlerResult()
            }
        }
        runLoop.add(timer, forMode: RunLoop.Mode.default)
        while !end {
            runLoop.run(until: Date.init(timeIntervalSinceNow: 3.0))
        }
        DispatchQueue.main.async {
//            self.indicator.stopAnimating()
        }
    }
}

extension LongDrageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: Constant.identifier)!
        cell.textLabel?.text = datas[indexPath.row]
        cell.textLabel?.textColor = UIColor.red
//        cell.textLabel?.textAlignment = .center
        if level != -1 {
            // 一级警报：绿标显示
            cell.textLabel?.textColor = UIColor.green
            cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        }
        return cell
    }
    
    
}

