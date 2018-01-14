import Foundation
import RxSwift


class FriendsViewModel {
    
    // MARK: - Properties
    
    public let friends: Variable<[Friend]> = Variable([])
    
    // MARK: - Initialization
    
    init() {
        getFriends()
    }
    
    // MARK: - Actions
    
    // MARK: - Helpers
    
    private func getFriends() {
        friends.value = [
            Friend(name: "Dagmara Eloelo", faceImage: #imageLiteral(resourceName: "Agata_Janowska"), event: "Wykład PKP"),
            Friend(name: "Tupand Tunald", faceImage: #imageLiteral(resourceName: "trump"), event: "Wykład TPK"),
            Friend(name: "Władzimiesz Nowak", faceImage: #imageLiteral(resourceName: "Diks"), event: nil),
            Friend(name: "Ganna Aocka", faceImage: #imageLiteral(resourceName: "ana"), event: "Wychowanie do życia w rodzinie"),
        ]
    }
}
