import Foundation
import UIKit
import RxSwift


class EventViewModel {
    // MARK: - Properties
    let events: Variable<[(header: String, [Event])]> = Variable([])
    private var timer: Timer!
    
    
    // MARK: - Actions
    func deleteEvent() {
        _ = ApiService.defaultInstance.abandon()
    }
    
    
    func startGettingEvents() {
        timer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(getEvents),
            userInfo: nil,
            repeats: true
        )
    }
    
    
    func stopGettingEvents() {
        timer.invalidate()
        timer = nil
    }
    
    
    // MARK: - Helpers
    @objc private func getEvents() {
        ApiService.defaultInstance.getEvents().then { [weak self](events) -> Void in
            self?.handleEvents(events: events)
        }
    }
    
    
    private func handleEvents(events: [Event]) {
        let headerOwning = R.string.events_list_owning^
        let headerParticipating = R.string.events_list_other^
        var owning: [Event] = []
        var participating: [Event] = []
        for event in events {
            if event.ownerId == ApiService.defaultInstance.userId {
                owning.append(event)
            } else {
                participating.append(event)
            }
        }
        self.events.value = []
        if !owning.isEmpty {
            self.events.value.append((headerOwning, owning))
        }
        if !participating.isEmpty {
            self.events.value.append((headerParticipating, participating))
        }
    }
}

