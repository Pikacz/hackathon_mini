import Foundation
import UIKit
import RxSwift

class ParticipaterVotesViewModel {
    
    // MARK: - Properties
    
    public let event: Variable<Event?> = Variable(nil)
    
    public let eventVote: Variable<Bool?> = Variable(nil)
    
    // MARK: - Actions
    
    func vote(postivie: Bool) {
        eventVote.value = postivie
        _ = ApiService.defaultInstance.sendVote(vote: postivie, eventID: (event.value?.id)!)
    }
    
    func resetVote() {
        eventVote.value = nil
    }
    
    // MARK: - Helpers
    
    func set(event: Event) {
        self.event.value = event
    }
    
}
