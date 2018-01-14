//
//  Event.swift
//  AngryStudent
//
//  Created by Mateusz Orzoł on 13.01.2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import Foundation
import ObjectMapper

class EventsData: Mappable {
    public private(set) var events: [Event]?
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        events  <- map["events"]
    }
}

class Event: Mappable {
    
    public private(set) var id: Int?
    public private(set) var name: String?
    public private(set) var description: String?
    public private(set) var ownerId: String?
    public private(set) var idnoorRoomId: String?
    public private(set) var iconName: String?
    public private(set) var yes: Int?
    public private(set) var no: Int?
    
    public init(name: String, num: Int, iconName: String, des: String?) {
        self.name = name
        self.iconName = iconName
        self.description = des
    }
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        id                 <- map["id"]
        name               <- map["name"]
        description        <- map["desc"]
        ownerId            <- map["owner-id"]
        idnoorRoomId       <- map["room-id"]
        iconName           <- map["icon"]
        yes                <- map["yes"]
        no                 <- map["no"]
    }
}
