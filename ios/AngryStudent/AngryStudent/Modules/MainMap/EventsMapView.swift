import UIKit
import IndoorwaySdk


protocol EventsMapViewDelegate: class {
    func eventsMapView(mapDidLoad view: EventsMapView)
    func eventsMapView(failedLoad view: EventsMapView, with error: Error)
    
    func eventsMapView(didSelect view: EventsMapView, object: IndoorwayObjectInfo)
}



class EventAnnotation: NSObject, IndoorwayAnnotation {
    var coordinate: IndoorwayLatLon
    var title: String?
    var subtitle: String?
    
    var reuseId: String
    var icon: UIImage?
    
    init(object: IndoorwayObjectInfo, icon: UIImage?) {
        self.coordinate = object.coordinate
        reuseId = object.objectId
        self.icon = icon
        super.init()
    }
}





class EventIcon: IndoorwayAnnotationView {
    private let imgView: UIImageView = UIImageView()
    
    override var annotation: IndoorwayAnnotation? {
        didSet {
            let annotation: EventAnnotation? = self.annotation as? EventAnnotation
            imgView.image = annotation?.icon?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            
        }
    }
    
    override init(annotation: IndoorwayAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    
    
    private func initialize() {
        let annotation: EventAnnotation? = self.annotation as? EventAnnotation
        imgView.image = annotation?.icon?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        backgroundColor = Color.blueLight
        imgView.tintColor = Color.blue
        addSubview(imgView)
        
        imgView.contentMode = UIViewContentMode.scaleAspectFit
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height/2.0
        
        let imgS: CGSize = CGSize(width: CGFloat(17.0), height: CGFloat(17.0))
        imgView.bounds.size = imgS
        imgView.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: CGFloat(35.0), height: CGFloat(35.0))
    }
}



extension IndoorwayMapView {
    var scrollView: UIScrollView {
        for view: UIView in subviews {
            if let sv: UIScrollView = view as? UIScrollView {
                return sv
            }
        }
        fatalError("")
    }
}

class EventsMapView: BasicView, IndoorwayMapViewDelegate {
    private let map: IndoorwayMapView = IndoorwayMapView()
    
    weak var delegate: EventsMapViewDelegate?
    var showsUserLocation: Bool = true
    
    
    override func initialize() {
        super.initialize()
        backgroundColor = Color.white
        addSubview(map)
        
        map.scrollView.maximumZoomScale = CGFloat(8.0)
        map.delegate = self
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        map.frame = bounds
    }
    
    
    func show(events: [Event]) {
        if events.isEmpty {
            map.stopNavigation()
        }
        var newAnnotations: [EventAnnotation] = []
        
        for event in events {
            guard let roomId: String = event.idnoorRoomId else { return }
            guard let object: IndoorwayObjectInfo = map.indoorObjects.first(where: { $0.objectId == roomId }) else { return }
            if event.imParticipate {
                map.navigate(to: object.coordinate)
            } else if event.imOwner {
                map.navigate(to: object.coordinate)
            } else {
                map.stopNavigation()
            }
            let annotation = EventAnnotation(object: object, icon: event.icon)
            newAnnotations.append(annotation)
        }
        
        let oldAnnotations = map.annotations.map {
            $0 as? EventAnnotation
        }.filter { $0 != nil }.map { $0! }
        
        var oldSet: Set<String> = []
        
        for old: EventAnnotation in oldAnnotations {
            oldSet.insert(old.reuseId)
        }
        
        var toAdd: [EventAnnotation] = []
        for new in newAnnotations {
            if !oldSet.contains(new.reuseId) {
                toAdd.append(new)
            } else {
                oldSet.remove(new.reuseId)
            }
        }
        
        let toRemove: [EventAnnotation] = oldAnnotations.filter { oldSet.contains($0.reuseId) }
        
        map.removeAnnotations(toRemove)
        map.addAnnotations(toAdd)
    }
    
    
    func load(with event: Event, completion: ((Bool) -> ())? = nil) {
        guard let objId: String = event.idnoorRoomId else {
            completion?(false)
            return
        }
        
        let desc: IndoorwayMapDescription = IndoorwayMapDescription(
            buildingUuid: ApiService.defaultInstance.indoorMiNI,
            mapUuid: IndoorwayMapDescription.getFloorId(fromObjId: objId)
        )
        showsUserLocation = false
        isUserInteractionEnabled = false
        load(with: desc) {
            (succeed: Bool) in
            if succeed {
                if let obj = self.map.indoorObjects.first(where: {
                    (obj: IndoorwayObjectInfo) -> Bool in
                    return obj.objectId == objId
                }) {
                    self.map.selectObject(withIndoorwayObject: obj)
                }
            }
            completion?(succeed)
        }
    }
    
    
    func load(with desc: IndoorwayMapDescription, completion: ((Bool) -> ())? = nil) {
        map.loadMap(with: desc) {
            [weak self] (succeed: Bool) in
            completion?(succeed)
            self?.map.showsUserLocation = succeed && (self?.showsUserLocation ?? false)
        }
    }
    
    // MARK: IndoorwayMapViewDelegate
    @objc func mapViewDidFinishLoadingMap(_ mapView: IndoorwayMapView) {
        delegate?.eventsMapView(mapDidLoad: self)
    }
    
    @objc func mapViewDidFailLoadingMap(_ mapView: IndoorwayMapView, withError error: Error) {
        delegate?.eventsMapView(failedLoad: self, with: error)
    }
    
    
    @objc func mapView(_ mapView: IndoorwayMapView, didTapLocation location: IndoorwayLatLon) {
    }
    
    
    @objc func mapView(_ mapView: IndoorwayMapView, didUpdate userLocation: IndoorwayUserLocation) {
    }
    
    
    @objc func mapView(_ mapView: IndoorwayMapView, didFailToLocateUserWithError error: Error) {
    }
    
    
    @objc func mapView(_ mapView: IndoorwayMapView, shouldSelectIndoorObject indoorObjectInfo: IndoorwayObjectInfo) -> Bool {
        return indoorObjectInfo.isRoom
    }
    
    
    @objc func mapView(_ mapView: IndoorwayMapView, didSelectIndoorObject indoorObjectInfo: IndoorwayObjectInfo) {
        
        delegate?.eventsMapView(didSelect: self, object: indoorObjectInfo)
        mapView.deselectObject()
        
    }
    

    @objc func mapView(_ mapView: IndoorwayMapView, viewForAnnotation annotation: IndoorwayAnnotation) -> IndoorwayAnnotationView? {
        var view: IndoorwayAnnotationView? = nil
        if let annotation: EventAnnotation = annotation as? EventAnnotation {
            if let reusedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.reuseId) {
                view = reusedView
            }
            else {
                let newView = EventIcon(annotation: annotation, reuseIdentifier: annotation.reuseId)
                newView.annotation = annotation
                newView.bounds.size = newView.intrinsicContentSize
                
                
                view = newView
            }
        }
        return view
    }
}

