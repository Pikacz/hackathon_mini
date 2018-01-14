import Foundation
import PromiseKit
import IndoorwaySdk
import ObjectMapper

extension ApiService {
  
  func createUser() -> Promise<Void> {
    return request(
      url: "\(baseUrl)/user/create?user-id=\(userId)",
      method: HTTPMethod.get, // TODO change to post xD
      parameters: nil,
      expectedCodes: [200],
      parser: {
        (json: String, code: Int) -> Void in
        return
    }
    )
  }
  
  
  @discardableResult func updatePossition(lat: Double, long: Double, floorId: String) -> Promise<Void> {
    return request(
      url: "\(baseUrl)/user/update-location?floor-id=\(floorId)&lat=\(lat)&lon=\(long)&user-id=\(userId)",
      method: HTTPMethod.get, // TODO change to post xD
      parameters: nil,
      expectedCodes: [200],
      parser: {
        (json: String, code: Int) -> Void in
        print(json)
        return
    }
    )
  }
  
  func createEvent(name: String, description: String, icon: String, roomId: String) -> Promise<Void> {
    let url = "\(baseUrl)/user/host-event"
    let params: [URLQueryItem] = [
      URLQueryItem(name: "owner-id", value: userId),
      URLQueryItem(name: "name", value: name),
      URLQueryItem(name: "icon", value: icon),
      URLQueryItem(name: "description", value: description),
      URLQueryItem(name: "room-id", value: roomId),
      ]
    
    
    
    var components = URLComponents(string: url)!
    components.queryItems = params
    components.percentEncodedQuery = components.percentEncodedQuery
    
    
    
    return request(
      url: components.url!.absoluteString,
      method: HTTPMethod.get,
      parameters: nil,
      expectedCodes: [200],
      parser: {
        (json: String, code: Int) -> Void in
        print(json)
        return
    }
    )
  }
  
  func getEvents() -> Promise<[Event]> {
    let url = "\(baseUrl)/user/data?user-id=\(userId)"
    print("😁 \(url)")
    return request(url: url,
                   method: HTTPMethod.get,
                   parameters: nil,
                   expectedCodes: [200],
                   parser: { (json, code) -> [Event] in
                    let events = Mapper<EventsData>().map(JSONString: json)
                    return events?.events ?? []
    })
  }
  
  func sendVote(vote: Bool, eventID: Int) -> Promise<Void> {
    let voteBool = vote ? 1 : 0
    let url = "\(baseUrl)/user/vote?user-id=\(userId)&value=\(voteBool)&event-id=\(eventID)"
    print("😁 \(url)")
    return request(url: url,
                   method: HTTPMethod.get,
                   parameters: nil,
                   expectedCodes: [200],
                   parser: { (json, code) -> Void in
                    print(json)
                    return
    })
  }
  
  func join(eventID: String) -> Promise<Void> {
    let url = "\(baseUrl)/user/join?user-id=\(userId)&event-id=\(eventID)"
    print("😁 \(url)")
    return request(url: url,
                   method: HTTPMethod.get,
                   parameters: nil,
                   expectedCodes: [200],
                   parser: { (json, code) -> Void in
                    print(json)
                    return
    })
  }
    
    func abandon() -> Promise<Void> {
        let url = "\(baseUrl)/user/abandon?user-id=\(userId)"
        print("😁 \(url)")
        return request(url: url,
                       method: HTTPMethod.get,
                       parameters: nil,
                       expectedCodes: [200],
                       parser: { (json, code) -> Void in
                        print(json)
                        return
        })
    }
  
  func statrtSpammingLocation() {
    spamLocationListener = LocationsListener()
    
    IndoorwayLocationSdk.instance().position.onChange.addListener(listener: spamLocationListener!)
    
    IndoorwayLocationSdk.instance().map.onChange.addListener(listener: spamLocationListener!)
  }
  
  func stopSpammingLocation() {
    guard let spamLocationListener: SpamLocationListener = spamLocationListener else {
      return
    }
    IndoorwayLocationSdk.instance().position.onChange.removeListener(listener: spamLocationListener)
    IndoorwayLocationSdk.instance().map.onChange.removeListener(listener: spamLocationListener)
    self.spamLocationListener = nil
  }
}


protocol SpamLocationListener: IndoorwayPositionListener, IndoorwayMapListener {
  
}

fileprivate class LocationsListener: SpamLocationListener {
  private var mapDesc: IndoorwayMapDescription? = nil {
    didSet {
      fire()
    }
  }
  private var position: IndoorwayLocation? = nil {
    didSet {
      fire()
    }
  }
  
  static let instance: LocationsListener = LocationsListener()
  
  init() {
    mapDesc = IndoorwayLocationSdk.instance().map.latest()
    position = IndoorwayLocationSdk.instance().position.latest()
  }
  
  
  
  private func fire() {
    guard let mapDesc: IndoorwayMapDescription = mapDesc else { return }
    guard let position: IndoorwayLocation = position else { return }
    ApiService.defaultInstance.updatePossition(lat: position.latitude, long: position.longitude, floorId: mapDesc.mapUuid)
  }
  
  // MARK: IndoorwayPositionListener
  func positionChanged(position: IndoorwayLocation) {
    self.position = position
  }
  
  // MARK: IndoorwayMapListener
  func mapChanged(map: IndoorwayMapDescription) {
    mapDesc = map
  }
}

