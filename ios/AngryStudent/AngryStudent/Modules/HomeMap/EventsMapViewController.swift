import UIKit
import IndoorwaySdk
import RxSwift



fileprivate let createEventSegue: String = "create_event"


class EventsMapViewController: BasicViewController, IndoorwayMapListener, IndoorwayPositionListener, EventsMapViewDelegate {
  @IBOutlet private weak var eventsMapView: EventsMapView! {
    didSet {
      updateMap()
      displayEvents()
      eventsMapView.delegate = self
    }
  }
  
  
  private var eventsDict: [String: Event] = [:]
  private var events: [Event] = []
  
  private var mapSyncing: Bool = false
  private var positionSyncing: Bool = false
  
  private var timer: Timer?
  
  private var currentMapDesc: IndoorwayMapDescription? {
    didSet {
      if currentMapDesc?.mapUuid != oldValue?.buildingUuid {
        updateMap()
      }
      
    }
  }
  
  deinit {
    if mapSyncing {
      IndoorwayLocationSdk.instance().map.onChange.removeListener(listener: self)
    }
    if positionSyncing {
      IndoorwayLocationSdk.instance().position.onChange.removeListener(listener: self)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    IndoorwayLocationSdk.instance().position.onChange.addListener(listener: self)
    positionSyncing = true
    IndoorwayLocationSdk.instance().map.onChange.addListener(listener: self)
    mapSyncing = true
    currentMapDesc = IndoorwayLocationSdk.instance().map.latest()
    isLoading = true
    
    navTitle = R.string.main_map_title["MiNI - 2nd floor"]
    view.backgroundColor = Color.white
    setupOwnerView()
    
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    
    timer = Timer.scheduledTimer(
      timeInterval: 3,
      target: self,
      selector: #selector(download),
      userInfo: nil,
      repeats: true
    )
    download()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    timer?.invalidate()
    timer = nil
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let identifier: String = segue.identifier ?? ""
    switch identifier {
    case createEventSegue:
      let dest: CreateEventViewController = segue.destination as! CreateEventViewController
      dest.room = sender as! IndoorwayObjectInfo
    default:
      break
    }
  }
  
  
  
  
  
  
  // MARK: EventsMapViewDelegate
  func eventsMapView(mapDidLoad view: EventsMapView) {
    displayEvents()
  }
  func eventsMapView(failedLoad view: EventsMapView, with error: Error) {}
  
  
  func eventsMapView(didSelect view: EventsMapView, object: IndoorwayObjectInfo) {
    
    if let event: Event = eventsDict[object.objectId] {
      if event.imOwner {
        eventsMapView.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 1) {
          self.ownerView.alpha = 1.0
        }
        print("jestem ownerem")
      } else {
        
      }
    } else {
      performSegue(withIdentifier: createEventSegue, sender: object)
    }
    
  }
  
  
  // MARK: private
  @objc private func download() {
    _ = ApiService.defaultInstance.getEvents().then {
      (events: [Event]) -> Void in
      self.update(events: events)
    }
  }
  
  private func update(events: [Event]) {
    for event: Event in events {
      if event.imOwner {
        ownerView.setup(model: event)
      }
      guard let roomId: String = event.idnoorRoomId else { continue }
      self.eventsDict[roomId] = event
    }
    self.events = events
    displayEvents()
  }
  
  
  private func displayEvents() {
    eventsMapView?.show(events: events)
  }
  
  
  // ****************************************************
  
  
  // MARK: IndoorwayPositionListener
  func positionChanged(position: IndoorwayLocation) {
    // needed for IndoorwayLocationSdk.instance().map.onChange to work :P
  }

  // MARK: IndoorwayMapListener
  func mapChanged(map: IndoorwayMapDescription) {
    
    currentMapDesc = map
  }
  
  // MARK: private
  private func updateMap() {
    if let mapDesc: IndoorwayMapDescription = currentMapDesc {
      
      isLoading = eventsMapView != nil
      eventsMapView?.load(with: mapDesc) {
        [weak self] (succed: Bool) in
        self?.isLoading = false
      }
    }
  }
  

  
    
    private let ownerViewModel = OwnerVotesViewModel()
    private let participateViewModel = ParticipaterVotesViewModel()
    private let disposeBag = DisposeBag()
    
    
    
    private let ownerView: OwnerVotesView = {
        $0.alpha = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(OwnerVotesView())
    
    private let participateView: ParticipaterVotesView = {
        $0.alpha = 0
        $0.nupButton.addTarget(self, action: #selector(voteNo), for: .touchUpInside)
        $0.yupButton.addTarget(self, action: #selector(voteYes), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(ParticipaterVotesView())
    

    
    
 
    // MARK: - Owner View
    
    // MARK: - Binding
    
    private func bindOwnerView() {

    }
    
    // MARK: - UI
    
    private func removeOwnerView() {
      //  UIView.animate(withDuration: 0.5) { [weak self] in
            self.ownerView.alpha = 0
       // }
    }
    
    private func addOwnerView(for id: String) {
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.ownerView.alpha = 1
        }
    }
    
    private func setupOwnerView() {
        self.view.addSubview(ownerView)
        setupOwnerViewConstrains()
        bindOwnerView()
      ownerView.alpha = 0.0
    }
    
    private func setupOwnerViewConstrains() {
        ownerView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10).isActive = true
        ownerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ownerView.widthAnchor.constraint(equalToConstant: 230).isActive = true
        ownerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    // MARK: - Participate View
    
    // MARK: - Setup
    
    private func bindParticipateView() {
        participateViewModel.event.asObservable().subscribe(onNext: { [weak self] (event) in
            guard let event = event else { return }
            self?.participateView.setup(model: event)
        }).disposed(by: disposeBag)
        
    }
    
    // MARK: - Actions
    
    @objc private func voteYes() {
        participateViewModel.vote(postivie: true)
    }
    
    @objc private func voteNo() {
        participateViewModel.vote(postivie: false)
    }
    
    // MARK: - UI
    
    private func removeParticipateView() {
       // UIView.animate(withDuration: 0.5) { [weak self] in
            self.participateView.alpha = 0
       // }
    }
    
    private func addParticipateView() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.participateView.alpha = 1
        }
    }
    
    private func setupParticipateView() {
        self.view.addSubview(participateView)
        setupParticipateViewConstrains()
        bindParticipateView()
    }
    
    private func setupParticipateViewConstrains() {
        participateView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10).isActive = true
        participateView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        participateView.widthAnchor.constraint(equalToConstant: 230).isActive = true
        participateView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
}
