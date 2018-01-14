import Foundation
import UIKit
import RxSwift


class OwnerVotesViewModel {
    
    // MARK: - Properties
    
    public let event: Variable<Event?> = Variable(nil)
    
    // MARK: - Initialization
    
    // MARK: - Actions
    
    // MARK: - Helpers
    
    public func setupEvent(for event: Event) {
        self.event.value = event
    }
    
    public func updateEvent(with event: Event) {
      self.event.value = event
    }
    
}
