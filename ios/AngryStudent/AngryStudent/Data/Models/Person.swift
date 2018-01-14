import Foundation
import ObjectMapper



struct Person: ImmutableMappable {
  let id: String
  let event_id: Int
  
  
  init(map: Map) throws {
    id = try map.value("user-id")
    event_id = try map.value("event-id")
  }
}
