import Foundation
import ObjectMapper
import UIKit

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
    public private(set) var guests: [String]?
  
  var icon: UIImage? {
    guard let iconName: String = iconName else { return nil }
    return UIImage(named: iconName)
  }
  
  var imOwner: Bool {
    return ownerId == ApiService.defaultInstance.userId
  }
  
  var imParticipate: Bool {
    return guests?.first { $0 == ApiService.defaultInstance.userId } != nil
  }
    
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
      guests               <- map["guests-id"]
      
      
      
    }
}
