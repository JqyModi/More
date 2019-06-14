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

class LongDrageViewController: UIViewController {

    @IBOutlet weak var longdrageMaxValue: UITextField!
    
    //表示当前是否在播放
    var isPlaying = false
    
    var type = 0 // 0: 赛车 1: 飞艇
    
    var offsetTime = 120 // 默认两分钟监听一次
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        longdrageMaxValue.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        longdrageMaxValue.resignFirstResponder()
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startListening(_ sender: UIButton) {
        
        longdrageMaxValue.resignFirstResponder()
        
        if let text = longdrageMaxValue.text, text != "" {
            let number = Int(text) ?? 0
            getDatas { (ldModel) in
                if let dragonModels = ldModel.data_result?.data_data {
                    for item in dragonModels {
                        let count = item.data_count
                        if count > number {
                            // 报警
                            //建立的SystemSoundID对象
//                            let soundID = SystemSoundID(kSystemSoundID_Vibrate)
                            //振动
//                            AudioServicesPlaySystemSound(soundID)
                            
                            if !self.isPlaying {
                                
                                let soundID = SystemSoundID(kSystemSoundID_Vibrate)
                                
                                //建立的SystemSoundID对象
//                                var soundID:SystemSoundID = 0
                                //获取声音地址
//                                let path = Bundle.main.path(forResource: "msg", ofType: "wav")
                                //地址转换
//                                let baseURL = NSURL(fileURLWithPath: path!)
                                //赋值
//                                AudioServicesCreateSystemSoundID(baseURL, &soundID)
                                
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
        }else {
            print("请输入长龙临界值")
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
extension LongDrageViewController {
//    #pragma mark - VoIP
//
//    - (void)setupBackgroundHandler
//    {
//    if( UIUDeviceIsBackgroundSupported() )
//
//    if(
//    [[UIApplication sharedApplication] setKeepAliveTimeout:600 handler: ^
//    {
//    [self requestServerHowManyUnreadMessages];
//    }
//    ]
//    )
//    {
//    UDLog(@"Set Background handler successed!");
//    }
//    else
//    {//failed
//    UDLog(@"Set Background handler failed!");
//    }
//    }
//    else
//    {
//    UDLog(@"This Deviece is not Background supported.");
//    }
//}

    func setupBackgroundHandler() {
        //
        if UIApplication.shared.setKeepAliveTimeout(600, handler: {
            self.requestServerHowManyUnreadMessages()
        }) {
            print("Set Background handler successed!")
        }else {
            print("Set Background handler failed!")
        }
    }
    
    func requestServerHowManyUnreadMessages() {
        let app = UIApplication.shared
        if app.applicationState == UIApplication.State.background {
            let oldNotifications = app.scheduledLocalNotifications
            if oldNotifications?.count ?? 0 > 0 {
                app.cancelAllLocalNotifications()
            }
            let alarm = UILocalNotification.init()
            alarm.fireDate = Date.init(timeIntervalSinceNow: 15)
            alarm.timeZone = TimeZone.current
            alarm.repeatInterval = []
            alarm.soundName = UILocalNotificationDefaultSoundName
            alarm.alertBody = "Time to request MOA2 Server!"
            app.scheduleLocalNotification(alarm)
        }else if app.applicationState == UIApplication.State.active {
            let alertView = UIAlertView()
            alertView.title = "alert"
            alertView.message = "Time to request MOA2 Server!"
            alertView.addButton(withTitle: "cancel")
            alertView.show()
        }
    }
}
