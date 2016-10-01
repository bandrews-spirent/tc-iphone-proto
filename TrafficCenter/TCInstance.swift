//
//  TCInstance.swift
//  TrafficCenter
//
//  Created by Andrews, Barry on 8/25/16.
//  Copyright © 2016 Spirent Communications. All rights reserved.
//

import UIKit

class TCInstance {
    var ipAddr: String
    var desc: String
    var image: UIImage?
    var statusImage: UIImage?
    
    init(ipAddr: String, desc: String, image: UIImage?, statusImage: UIImage?) {
        self.ipAddr = ipAddr
        self.desc = desc
        self.image = image
        self.statusImage = statusImage
    }
}
