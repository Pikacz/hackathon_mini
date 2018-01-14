//
//  OwnerVotesViewModel.swift
//  AngryStudent
//
//  Created by Mateusz Orzoł on 13.01.2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class OwnerVotesViewModel {
    
    // MARK: - Properties
    
    public let groupEvent: Variable<Event?> = Variable(nil)
    
    // MARK: - Initialization
    
    init() {
        getEvents()
    }
    
    // MARK: - Actions
    
    // MARK: - Helpers
    
    private func getEvents() {
      
    }
    
}
