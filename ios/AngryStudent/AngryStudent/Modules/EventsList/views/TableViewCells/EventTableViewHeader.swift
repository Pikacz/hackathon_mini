import Foundation
import UIKit


class EventTableViewHeader: BasicView {
    
    // MARK: - Outlets
    
    private let nameLabel: UILabel = {
        $0.textColor = Color.blueDark
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.lineBreakMode = .byTruncatingTail
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    // MARK: - Inititalization
    
    override public func initialize() {
        super.initialize()
        setupUI()
    }
    
    // MARK: - Helpers
    
    public func setup(with title: String?) {
        nameLabel.text = title
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        self.backgroundColor = Color.gray
        addSubview(nameLabel)
        setupNameLabel()
    }
    
    private func setupNameLabel() {
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}

