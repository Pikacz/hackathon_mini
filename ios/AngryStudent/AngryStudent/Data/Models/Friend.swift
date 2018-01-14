import Foundation
import UIKit


class Friend {
    let name: String
    let faceIamge: UIImage
    let event: String?
    
    init(name: String, faceImage: UIImage, event: String?) {
        self.name = name
        self.faceIamge = faceImage
        self.event = event
    }
}

