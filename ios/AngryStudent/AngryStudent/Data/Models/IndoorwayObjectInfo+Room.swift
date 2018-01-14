import Foundation
import IndoorwaySdk


fileprivate let idToNumber: [String: String] = [
    "3-_M01M3r5w_36a38": "211",
    "3-_M01M3r5w_76b29": "212",
    "3-_M01M3r5w_fe9c8": "213",
    "3-_M01M3r5w_c1a68": "214",
    "3-_M01M3r5w_ca808": "216",
    "gVI7XXuBFCQ_c0b28": "103",
    "gVI7XXuBFCQ_a18d9": "107",
]


fileprivate let idToCenterCoord: [String: IndoorwayLatLon] = [
    "3-_M01M3r5w_36a38": IndoorwayLatLon(latitude: 52.2219589680484, longitude: 21.0067591639562),
    "3-_M01M3r5w_76b29": IndoorwayLatLon(latitude: 52.2220465705931, longitude: 21.0067572030207),
    "3-_M01M3r5w_fe9c8": IndoorwayLatLon(latitude: 52.2221348895405, longitude: 21.0067570552191),
    "3-_M01M3r5w_c1a68": IndoorwayLatLon(latitude: 52.222219869846, longitude: 21.0067581477856),
    "3-_M01M3r5w_ca808": IndoorwayLatLon(latitude: 52.2223362891784, longitude: 21.0067557652251),
    
    "gVI7XXuBFCQ_c0b28": IndoorwayLatLon(latitude: 52.2222260223577, longitude: 21.0067850431649),
    "gVI7XXuBFCQ_a18d9": IndoorwayLatLon(latitude: 52.22214602921, longitude: 21.0071133361957),
]


extension IndoorwayObjectInfo {
    var roomName: String? {
        guard let number: String = idToNumber[self.objectId] else {
            return nil
        }
        return R.string.common_room_name[number]
    }
    
    var isRoom: Bool {
        return idToNumber[objectId] != nil
    }
    
    var coordinate: IndoorwayLatLon {
        return idToCenterCoord[objectId]!
    }
}


