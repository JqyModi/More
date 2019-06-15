//
//  DoubleModel.swift
//  More
//
//  Created by Modi on 2019/6/15.
//  Copyright © 2019年 modi. All rights reserved.
//

import ObjectMapper

class DoubleData: Mappable {
    var data_fifthBigCount: Int = 0
    var data_drawCount: Int = 0
    var data_sixthSmallCount: Int = 0
    var data_fourthDoubleCount: Int = 0
    var data_tenthBigCount: Int = 0
    var data_thirdSmallCount: Int = 0
    var data_eighthDoubleCount: Int = 0
    var data_ninthSingleCount: Int = 0
    var data_fifthDragonCount: Int = 0
    var data_preDrawIssue: Double = 0
    var data_id: Int = 0
    var data_fourthSingleCount: Int = 0
    var data_secondBigCount: Int = 0
    var data_eighthSingleCount: Int = 0
    var data_eighthBigCount: Int = 0
    var data_eighthSmallCount: Int = 0
    var data_preDrawTime: String?
    var data_seventhDoubleCount: Int = 0
    var data_sumDoubleCount: Int = 0
    var data_secondDragonCount: Int = 0
    var data_secondTigerCount: Int = 0
    var data_firstBigCount: Int = 0
    var data_firstSingleCount: Int = 0
    var data_fourthBigCount: Int = 0
    var data_ninthDoubleCount: Int = 0
    var data_tenthSmallCount: Int = 0
    var data_preDrawCode: String?
    var data_thirdSingleCount: Int = 0
    var data_ninthSmallCount: Int = 0
    var data_fourthDragonCount: Int = 0
    var data_sixthSingleCount: Int = 0
    var data_fourthSmallCount: Int = 0
    var data_enable: Int = 0
    var data_firstDoubleCount: Int = 0
    var data_seventhBigCount: Int = 0
    var data_preDrawDate: String?
    var data_sumSmallCount: Int = 0
    var data_firstTigerCount: Int = 0
    var data_thirdDoubleCount: Int = 0
    var data_thirdBigCount: Int = 0
    var data_sixthBigCount: Int = 0
    var data_sumBigCount: Int = 0
    var data_ninthBigCount: Int = 0
    var data_sumSingleCount: Int = 0
    var data_fifthTigerCount: Int = 0
    var data_firstSmallCount: Int = 0
    var data_sixthDoubleCount: Int = 0
    var data_firstDragonCount: Int = 0
    var data_fifthSmallCount: Int = 0
    var data_fourthTigerCount: Int = 0
    var data_thirdDragonCount: Int = 0
    var data_fifthSingleCount: Int = 0
    var data_seventhSmallCount: Int = 0
    var data_tenthSingleCount: Int = 0
    var data_secondDoubleCount: Int = 0
    var data_seventhSingleCount: Int = 0
    var data_fifthDoubleCount: Int = 0
    var data_secondSingleCount: Int = 0
    var data_drawIssue: Double = 0
    var data_thirdTigerCount: Int = 0
    var data_drawTime: String?
    var data_tenthDoubleCount: Int = 0
    var data_secondSmallCount: Int = 0
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        data_fifthBigCount <- map["fifthBigCount"]
        data_drawCount <- map["drawCount"]
        data_sixthSmallCount <- map["sixthSmallCount"]
        data_fourthDoubleCount <- map["fourthDoubleCount"]
        data_tenthBigCount <- map["tenthBigCount"]
        data_thirdSmallCount <- map["thirdSmallCount"]
        data_eighthDoubleCount <- map["eighthDoubleCount"]
        data_ninthSingleCount <- map["ninthSingleCount"]
        data_fifthDragonCount <- map["fifthDragonCount"]
        data_preDrawIssue <- map["preDrawIssue"]
        data_id <- map["id"]
        data_fourthSingleCount <- map["fourthSingleCount"]
        data_secondBigCount <- map["secondBigCount"]
        data_eighthSingleCount <- map["eighthSingleCount"]
        data_eighthBigCount <- map["eighthBigCount"]
        data_eighthSmallCount <- map["eighthSmallCount"]
        data_preDrawTime <- map["preDrawTime"]
        data_seventhDoubleCount <- map["seventhDoubleCount"]
        data_sumDoubleCount <- map["sumDoubleCount"]
        data_secondDragonCount <- map["secondDragonCount"]
        data_secondTigerCount <- map["secondTigerCount"]
        data_firstBigCount <- map["firstBigCount"]
        data_firstSingleCount <- map["firstSingleCount"]
        data_fourthBigCount <- map["fourthBigCount"]
        data_ninthDoubleCount <- map["ninthDoubleCount"]
        data_tenthSmallCount <- map["tenthSmallCount"]
        data_preDrawCode <- map["preDrawCode"]
        data_thirdSingleCount <- map["thirdSingleCount"]
        data_ninthSmallCount <- map["ninthSmallCount"]
        data_fourthDragonCount <- map["fourthDragonCount"]
        data_sixthSingleCount <- map["sixthSingleCount"]
        data_fourthSmallCount <- map["fourthSmallCount"]
        data_enable <- map["enable"]
        data_firstDoubleCount <- map["firstDoubleCount"]
        data_seventhBigCount <- map["seventhBigCount"]
        data_preDrawDate <- map["preDrawDate"]
        data_sumSmallCount <- map["sumSmallCount"]
        data_firstTigerCount <- map["firstTigerCount"]
        data_thirdDoubleCount <- map["thirdDoubleCount"]
        data_thirdBigCount <- map["thirdBigCount"]
        data_sixthBigCount <- map["sixthBigCount"]
        data_sumBigCount <- map["sumBigCount"]
        data_ninthBigCount <- map["ninthBigCount"]
        data_sumSingleCount <- map["sumSingleCount"]
        data_fifthTigerCount <- map["fifthTigerCount"]
        data_firstSmallCount <- map["firstSmallCount"]
        data_sixthDoubleCount <- map["sixthDoubleCount"]
        data_firstDragonCount <- map["firstDragonCount"]
        data_fifthSmallCount <- map["fifthSmallCount"]
        data_fourthTigerCount <- map["fourthTigerCount"]
        data_thirdDragonCount <- map["thirdDragonCount"]
        data_fifthSingleCount <- map["fifthSingleCount"]
        data_seventhSmallCount <- map["seventhSmallCount"]
        data_tenthSingleCount <- map["tenthSingleCount"]
        data_secondDoubleCount <- map["secondDoubleCount"]
        data_seventhSingleCount <- map["seventhSingleCount"]
        data_fifthDoubleCount <- map["fifthDoubleCount"]
        data_secondSingleCount <- map["secondSingleCount"]
        data_drawIssue <- map["drawIssue"]
        data_thirdTigerCount <- map["thirdTigerCount"]
        data_drawTime <- map["drawTime"]
        data_tenthDoubleCount <- map["tenthDoubleCount"]
        data_secondSmallCount <- map["secondSmallCount"]
    }
}

class DoubleResult: Mappable {
    var data_businessCode: Int = 0
    var data_data: DoubleData?
    var data_message: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        data_businessCode <- map["businessCode"]
        data_data <- map["data"]
        data_message <- map["message"]
    }
}

class DoubleModel: Mappable {
    var data_message: String?
    var data_result: DoubleResult?
    var data_errorCode: Int = 0
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        data_message <- map["message"]
        data_result <- map["result"]
        data_errorCode <- map["errorCode"]
    }
}
