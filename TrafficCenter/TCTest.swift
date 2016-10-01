//
//  TCTest.swift
//  TrafficCenter
//
//  Created by Andrews, Barry on 8/27/16.
//  Copyright © 2016 Spirent Communications. All rights reserved.
//

import UIKit

class TCTest {
    var name: String
    var desc: String
    var id: String
    var error: String
    var playing: Bool
    var status = ""
    var progress = 0
    var grade = ""
    var lastReportId = ""
    
    init(name: String, desc: String, id: String, error: String, playing: Bool){
        self.name = name
        self.desc = desc
        self.id = id
        self.error = error
        self.playing = playing
    }
}
