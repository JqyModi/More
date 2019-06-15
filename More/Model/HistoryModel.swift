//
//  HistoryModel.swift
//  More
//
//  Created by Modi on 2019/6/15.
//  Copyright © 2019年 modi. All rights reserved.
//

import ObjectMapper

class HistoryData: Mappable {
    var data_thirdDT: Int = 0
    var data_fourthDT: Int = 0
    var data_preDrawCode: String?
    var data_firstDT: Int = 0
    var data_sumFS: Int = 0
    var data_preDrawTime: String?
    var data_fifthDT: Int = 0
    var data_groupCode: Int = 0
    var data_preDrawIssue: Int = 0
    var data_secondDT: Int = 0
    var data_sumBigSamll: Int = 0
    var data_sumSingleDouble: Int = 0
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        data_thirdDT <- map["thirdDT"]
        data_fourthDT <- map["fourthDT"]
        data_preDrawCode <- map["preDrawCode"]
        data_firstDT <- map["firstDT"]
        data_sumFS <- map["sumFS"]
        data_preDrawTime <- map["preDrawTime"]
        data_fifthDT <- map["fifthDT"]
        data_groupCode <- map["groupCode"]
        data_preDrawIssue <- map["preDrawIssue"]
        data_secondDT <- map["secondDT"]
        data_sumBigSamll <- map["sumBigSamll"]
        data_sumSingleDouble <- map["sumSingleDouble"]
    }
}

class HistoryResult: Mappable {
    var data_businessCode: Int = 0
    var data_data: [HistoryData]?
    var data_message: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        data_businessCode <- map["businessCode"]
        data_data <- map["data"]
        data_message <- map["message"]
    }
}

class HistoryModel: Mappable {
    var data_message: String?
    var data_result: HistoryResult?
    var data_errorCode: Int = 0
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        data_message <- map["message"]
        data_result <- map["result"]
        data_errorCode <- map["errorCode"]
    }
}
