//
//  EventViewModel.swift
//  AngryStudent
//
//  Created by Mateusz Orzoł on 13.01.2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class EventViewModel {
    
    // MARK: - Properties
    
    public let events: Variable<[(header: String, [Event])]> = Variable([])
    private var timer: Timer!
    
    // MARK: - Initialization
    
    // MARK: - Actions
    
    func openOwnerEventInfo() {
        
    }
    
    func openParticipateEventInfo() {
        
    }
    
    public func startGettingEvents() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getEvents), userInfo: nil, repeats: true)
    }
    
    public func stopGettingEvents() {
        timer.invalidate()
    }
    
    // MARK: - Helpers
    
    @objc private func getEvents() {
        ApiService.defaultInstance.getEvents().then { [weak self](events) -> Void in
            self?.handleEvents(events: events)
        }
    }
    
    private func handleEvents(events: [Event]) {
        let headerOwning = "Owning"
        let headerParticipating = "Participating"
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
