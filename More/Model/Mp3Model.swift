//
//  Mp3Model.swift
//  More
//
//  Created by Modi on 2019/6/15.
//  Copyright © 2019年 modi. All rights reserved.
//

import DOUAudioStreamer

class Mp3Model: NSObject, DOUAudioFile {
    func audioFileURL() -> URL! {
        if let path = Bundle.main.path(forResource: "silent.mp3", ofType: nil) {
            let url = URL(fileURLWithPath: path)
            return url
        }
        return URL(string: "http://cache.musicz.co/music/mp3/53863054034879819065867733833771.mp3")
    }
}
