import Foundation
import IndoorwaySdk


class MapService {
    static let instance: MapService = MapService()
    
    private let roomToFloor: [String: String] = [
        "3-_M01M3r5w_ca808": "",
        "3-_M01M3r5w_2ab48": "",
        "3-_M01M3r5w_c1a68": "",
        "3-_M01M3r5w_76b29": "",
        "3-_M01M3r5w_36a38": "",
        "3-_M01M3r5w_2ab48": "",
        "3-_M01M3r5w_8a8f9": "",
        "3-_M01M3r5w_8a8f9": "",
        "3-_M01M3r5w_14828": "",
        "3-_M01M3r5w_2098a": "",
        ]
    
    
    
    func getFloor(indoorObjectInfo object: IndoorwayObjectInfo) -> String? {
        return roomToFloor[object.objectId]
    }
}
