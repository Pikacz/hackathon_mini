//
//  ParticipaterVotesViewModel.swift
//  AngryStudent
//
//  Created by Mateusz Orzoł on 13.01.2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ParticipaterVotesViewModel {
    
    // MARK: - Properties
    
    public let event: Variable<Event?> = Variable(nil)
    
    // MARK: - Initialization
    
    // MARK: - Actions
    
    func vote(postivie: Bool) {
        _ = ApiService.defaultInstance.sendVote(vote: postivie, eventID: (event.value?.idnoorRoomId)!)
    }
    
    // MARK: - Helpers
    
    func set(event: Event) {
        self.event.value = event
    }
    
}
