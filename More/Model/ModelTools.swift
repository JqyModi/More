//
//  ModelTools.swift
//  More
//
//  Created by Modi on 2019/6/15.
//  Copyright © 2019年 modi. All rights reserved.
//

import UIKit
import ObjectMapper
import AVFoundation

let baseURL = "https://api.api861861.com/pks/"
let longDragonAPI = baseURL + "getPksLongDragonCount.do?date=&lotCode="
let doubleAPI = baseURL + "getPksDoubleCount.do?date=&lotCode="
let historyAPI = baseURL + "getPksHistoryList.do?lotCode="

class ModelTools: NSObject {

    class func longDragonDatas(lotCode: String = "10001", finished: ((_ model: LongDragonModel)->Void)?) {
        let urls = longDragonAPI + lotCode
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
    
    
    class func doubleDatas(lotCode: String = "10001", finished: ((_ model: DoubleModel)->Void)?) {
        let urls = doubleAPI + lotCode
        let config = URLSessionConfiguration.default
        let us = URLSession(configuration: config)
        guard let url = URL(string: urls) else {
            return
        }
        let task = us.dataTask(with: url) { (data, response, error) in
            if let d = data {
                let jsonStr = String.init(data: d, encoding: String.Encoding.utf8) ?? ""
                //                let json = try! JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableLeaves)
                if let ldModel = Mapper<DoubleModel>().map(JSONString: jsonStr) {
                    if let b = finished {
                        b(ldModel)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func historyDatas(lotCode: String = "10001", finished: ((_ model: HistoryModel)->Void)?) {
        let urls = historyAPI + lotCode
        let config = URLSessionConfiguration.default
        let us = URLSession(configuration: config)
        guard let url = URL(string: urls) else {
            return
        }
        let task = us.dataTask(with: url) { (data, response, error) in
            if let d = data {
                let jsonStr = String.init(data: d, encoding: String.Encoding.utf8) ?? ""
                //                let json = try! JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableLeaves)
                if let ldModel = Mapper<HistoryModel>().map(JSONString: jsonStr) {
                    if let b = finished {
                        b(ldModel)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func rankMappingToString(tag: Int) -> String {
        var text = ""
        switch tag {
        case 1: // 冠军
            text = "冠军"
            break
        case 2:
            text = "亚军"
            break
        case 3:
            text = "季军"
            break
        case 4:
            text = "第四名"
            break
        case 5:
            text = "第五名"
            break
        case 6:
            text = "第六名"
            break
        case 7:
            text = "第七名"
            break
        case 8:
            text = "第八名"
            break
        case 9:
            text = "第九名"
            break
        case 10:
            text = "第十名"
            break
        case 11: // 冠亚和
            text = "冠亚和"
            break
        default:
            break
        }
        return text
    }
    
    class func stateMappingToString(tag: Int) -> String {
        var text = ""
        switch tag {
        case 1: // 冠军
            text = "单"
            break
        case 2:
            text = "双"
            break
        case 3:
            text = "大"
            break
        case 4:
            text = "小"
            break
        case 5:
            text = "龙"
            break
        case 6:
            text = "虎"
            break
        default:
            break
        }
        return text
    }
    
    /// 获取双面差值
    ///
    /// - Parameters:
    ///   - tag: 开奖号码
    ///   - type: 类型：1：单双 2：大小 3: 龙虎
    /// - Returns: 差值
    class func doubleOffsetByTag(tag: Int, type: Int) -> Int {
        var result = 0
        self.doubleDatas { (model) in
            guard let doubleModel = model.data_result?.data_data else {return}
            switch tag {
            case 1: // 冠军
                if type == 1 {
                    result = doubleModel.data_firstSingleCount - doubleModel.data_firstDoubleCount
                }else if type == 2 {
                    result = doubleModel.data_firstBigCount - doubleModel.data_firstSmallCount
                }else {
                    result = doubleModel.data_firstTigerCount - doubleModel.data_firstDragonCount
                }
                break
            case 2:
                if type == 1 {
                    result = doubleModel.data_secondSingleCount - doubleModel.data_secondDoubleCount
                }else if type == 2 {
                    result = doubleModel.data_secondBigCount - doubleModel.data_secondSmallCount
                }else {
                    result = doubleModel.data_secondTigerCount - doubleModel.data_secondDragonCount
                }
                break
            case 3:
                if type == 1 {
                    result = doubleModel.data_thirdSingleCount - doubleModel.data_thirdDoubleCount
                }else if type == 2 {
                    result = doubleModel.data_thirdBigCount - doubleModel.data_thirdSmallCount
                }else {
                    result = doubleModel.data_thirdTigerCount - doubleModel.data_thirdDragonCount
                }
                break
            case 4:
                if type == 1 {
                    result = doubleModel.data_fourthSingleCount - doubleModel.data_fourthDoubleCount
                }else if type == 2 {
                    result = doubleModel.data_fourthBigCount - doubleModel.data_fourthSmallCount
                }else {
                    result = doubleModel.data_fourthTigerCount - doubleModel.data_fourthDragonCount
                }
                break
            case 5:
                if type == 1 {
                    result = doubleModel.data_fifthSingleCount - doubleModel.data_fifthDoubleCount
                }else if type == 2 {
                    result = doubleModel.data_fifthBigCount - doubleModel.data_fifthSmallCount
                }else {
                    result = doubleModel.data_fifthTigerCount - doubleModel.data_fifthDragonCount
                }
                break
            case 6:
                if type == 1 {
                    result = doubleModel.data_sixthSingleCount - doubleModel.data_sixthDoubleCount
                }else if type == 2 {
                    result = doubleModel.data_sixthBigCount - doubleModel.data_sixthSmallCount
                }
                break
            case 7:
                if type == 1 {
                    result = doubleModel.data_seventhSingleCount - doubleModel.data_seventhDoubleCount
                }else if type == 2 {
                    result = doubleModel.data_seventhBigCount - doubleModel.data_seventhSmallCount
                }
                break
            case 8:
                if type == 1 {
                    result = doubleModel.data_eighthSingleCount - doubleModel.data_eighthDoubleCount
                }else if type == 2 {
                    result = doubleModel.data_eighthBigCount - doubleModel.data_eighthSmallCount
                }
                break
            case 9:
                if type == 1 {
                    result = doubleModel.data_ninthSingleCount - doubleModel.data_ninthDoubleCount
                }else if type == 2 {
                    result = doubleModel.data_ninthBigCount - doubleModel.data_ninthSmallCount
                }
                break
            case 10:
                if type == 1 {
                    result = doubleModel.data_tenthSingleCount - doubleModel.data_tenthDoubleCount
                }else if type == 2 {
                    result = doubleModel.data_tenthBigCount - doubleModel.data_tenthSmallCount
                }
                break
            case 11: // 冠亚和
                if type == 1 {
                    result = doubleModel.data_sumSingleCount - doubleModel.data_sumDoubleCount
                }else if type == 2 {
                    result = doubleModel.data_sumBigCount - doubleModel.data_sumSmallCount
                }
                break
            default:
                break
            }
        }
        
        return 0
    }
    
    class func getCurrentIssue(lotCode: String = "10001", finished: ((_ issue: Double)->Void)?) {
        doubleDatas(lotCode: lotCode, finished: { (model) in
            guard let doubleModel = model.data_result?.data_data else {return}
            if let f = finished {
                f(doubleModel.data_drawIssue)
            }
        })
    }
}

// MARK: - 核心算法
extension ModelTools {
    
    class func analysisLongDragon(lotCode: String, number: Int, doubleNumber: Int, finished: ((_ result: String)->Void)?) {
        
        self.longDragonDatas(lotCode: lotCode) { (model) in
            guard let dragonModels = model.data_result?.data_data else {return}
            
            for i in 0..<dragonModels.count {
                let item = dragonModels[i]
                let d = item.data_rank
                let count = item.data_count
                let state = item.data_state
                // 1.长龙超过给定数值
                if count >= number {
                    // 一级警报
                    let text = ModelTools.rankMappingToString(tag: d) + ModelTools.stateMappingToString(tag: state) + "\(count)期"
                    print(text)
                    // 3.根据当前分析号码去获取双面分析差值是否超过给定数值
                    var type = -1
                    switch state {
                    case 1,2:
                        type = 1
                        break
                    case 3,4:
                        type = 2
                        break
                    case 5,6:
                        type = 3
                        break
                    default:
                        break
                    }
                    let offset = ModelTools.doubleOffsetByTag(tag: d, type: state)
                    if offset >= doubleNumber {
                        // 三级报警：双面差值比较
                        let pt = "双面差值已达到临界条件"
                        self.playSoundByText(text: pt, lotCode: lotCode)
                        if let f = finished {
                            f(text)
                        }
                    }else {
                        self.playSoundByText(text: text, lotCode: lotCode)
                        if let f = finished {
                            f(text)
                        }
                    }
                }
                
                for j in i+1..<dragonModels.count {
                    let item1 = dragonModels[j]
                    // 2.长龙并列超过给定数值：如单8期 + 大8期 = 双+小
                    if d == item1.data_rank, item1.data_count >= number {
                        // 二级警报
                        let text = ModelTools.rankMappingToString(tag: d) + ModelTools.stateMappingToString(tag: state) + "\(count)期" + ModelTools.stateMappingToString(tag: item1.data_state) + "\(item1.data_count)期"
                        print(text)
                        if let f = finished {
                            f(text)
                        }
                        
                        self.playSoundByText(text: text, lotCode: lotCode)
                        break
                    }
                }
            }
        }
    }
    
    class func analysisHistory(model: HistoryModel) {
        
    }
    
    /// 语音播报当前报警信息
    ///
    /// - Parameter model: -
    class func playSoundByText(text: String, lotCode: String) {
        _ = ModelTools.getCurrentIssue(lotCode: lotCode) { (issue) in
            let tempIssue = String(Int(issue))
            let utterance = AVSpeechUtterance.init(string: "当前开奖期号为\(tempIssue.mySubString(from: tempIssue.count-3))期" + text)
            let synth = AVSpeechSynthesizer()
            synth.speak(utterance)
        }
    }
}
extension String {
    func mySubString(to index: Int) -> String {
        return String(self[..<self.index(self.startIndex, offsetBy: index)])
    }
    
    func mySubString(from index: Int) -> String {
        return String(self[self.index(self.startIndex, offsetBy: index)...])
    }
}
