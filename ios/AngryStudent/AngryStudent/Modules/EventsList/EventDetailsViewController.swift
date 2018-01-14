import Foundation


class EventDetailsViewController: BasicViewController {
    @IBOutlet private weak var mapView: EventsMapView!
    
    var event: Event!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.load(with: event)
    }
}

