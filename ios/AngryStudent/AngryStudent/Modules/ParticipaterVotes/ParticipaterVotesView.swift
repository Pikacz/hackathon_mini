import Foundation
import UIKit

class  ParticipaterVotesView: BasicView  {
    
    // MARK: - Delegate
    
    // MARK: - Properties
    
    // MARK: - Outlets
    
    private let bcgView: UIView = {
        $0.backgroundColor = Color.white
        $0.layer.cornerRadius = 7
        $0.alpha = 0.85
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private let evnetImageView: UIImageView = {
        $0.backgroundColor = Color.clear
        $0.tintColor = Color.blue
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private let desLabel: UILabel = {
        $0.textColor = Color.blueDark
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.lineBreakMode = .byTruncatingTail
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let topStackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 5
        $0.isUserInteractionEnabled = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    public lazy var yupButton: UIButton = {
        $0.setImage(#imageLiteral(resourceName: "Up"), for: UIControlState.normal)
        $0.tintColor = Color.green
        $0.backgroundColor = Color.clear
        $0.isUserInteractionEnabled = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton(type: UIButtonType.system))
    
    public lazy var nupButton: UIButton = {
        $0.setImage(#imageLiteral(resourceName: "down"), for: UIControlState.normal)
        $0.tintColor = Color.red
        $0.backgroundColor = Color.clear
        $0.isUserInteractionEnabled = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton(type: UIButtonType.system))
    
    private let votesStackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 35
        $0.isUserInteractionEnabled = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    // MARK: - Inititalization
    
    override public func initialize() {
        super.initialize()
        setupUI()
    }
    
    // MARK: - Helpers
    
    func setup(model: Event) {
        if let iconName = model.iconName {
            evnetImageView.image = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate)
        }
        desLabel.text = model.name
    }
    
    func setup(vote: Bool?) {
        guard let vote = vote else {
            yupButton.tintColor = Color.grayDark
            nupButton.tintColor = Color.grayDark
            return
        }
        yupButton.tintColor = vote ? Color.green : Color.grayDark
        nupButton.tintColor = !vote ? Color.red : Color.grayDark
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        self.backgroundColor = Color.clear
        addSubview(bcgView)
        topStackView.addArrangedSubview(evnetImageView)
        topStackView.addArrangedSubview(desLabel)
        addSubview(topStackView)
        votesStackView.addArrangedSubview(yupButton)
        votesStackView.addArrangedSubview(nupButton)
        addSubview(votesStackView)
        setupBcgView()
        setupEventImageView()
        setupOkBadImageVIews()
        setupTopStackView()
        setupVotesStackView()
    }
    
    private func setupBcgView() {
        bcgView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bcgView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bcgView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bcgView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func setupEventImageView() {
        evnetImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        evnetImageView.heightAnchor.constraint(equalTo: evnetImageView.widthAnchor).isActive = true
    }
    
    private func setupOkBadImageVIews() {
        yupButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        yupButton.heightAnchor.constraint(equalTo: yupButton.widthAnchor).isActive = true
        nupButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nupButton.heightAnchor.constraint(equalTo: nupButton.widthAnchor).isActive = true
    }
    
    private func setupTopStackView() {
        topStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        topStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    private func setupVotesStackView() {
        votesStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 15).isActive = true
        votesStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
