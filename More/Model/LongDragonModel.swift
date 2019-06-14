//
//  LongDragonModel.swift
//  More
//
//  Created by Modi on 2019/6/13.
//  Copyright © 2019年 modi. All rights reserved.
//

import ObjectMapper

class Data: Mappable {
    var data_state: Int = 0
    var data_count: Int = 0
    var data_rank: Int = 0
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        data_state <- map["state"]
        data_count <- map["count"]
        data_rank <- map["rank"]
    }
}

class Result: Mappable {
    var data_businessCode: Int = 0
    var data_message: String?
    var data_data: [Data]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        data_businessCode <- map["businessCode"]
        data_message <- map["message"]
        data_data <- map["data"]
    }
}

class LongDragonModel: Mappable {
    var data_message: String?
    var data_result: Result?
    var data_errorCode: Int = 0
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        data_message <- map["message"]
        data_result <- map["result"]
        data_errorCode <- map["errorCode"]
    }
}
