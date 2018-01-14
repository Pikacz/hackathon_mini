import Foundation
import IndoorwaySdk


fileprivate let idToFloor: [String: Int] = [
    "7-QLYjkafkE": 0,
    "gVI7XXuBFCQ": 1,
    "3-_M01M3r5w": 2,
]


fileprivate let objIdToFloorId: [String: String] = [
    "3-_M01M3r5w_36a38": "3-_M01M3r5w",
    "3-_M01M3r5w_76b29": "3-_M01M3r5w",
    "3-_M01M3r5w_fe9c8": "3-_M01M3r5w",
    "3-_M01M3r5w_c1a68": "3-_M01M3r5w",
    "3-_M01M3r5w_ca808": "3-_M01M3r5w",
    "gVI7XXuBFCQ_c0b28": "gVI7XXuBFCQ",
    "gVI7XXuBFCQ_a18d9": "gVI7XXuBFCQ",
]


extension IndoorwayMapDescription {
    var floor: Int? {
        return idToFloor[mapUuid]
    }
    
    static func getFloorId(fromObjId objId: String) -> String {
        return objIdToFloorId[objId]!
    }
}

