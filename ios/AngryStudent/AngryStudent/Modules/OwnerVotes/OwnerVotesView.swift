//
//  OwnerVotesView.swift
//  AngryStudent
//
//  Created by Mateusz Orzoł on 13.01.2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import Foundation
import UIKit

class  OwnerVotesView: BasicView  {
    
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
    
    private let iconImageView: UIImageView = {
        $0.backgroundColor = Color.clear
        $0.image = #imageLiteral(resourceName: "Users")
        $0.tintColor = Color.blueDark
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private let nrLabel: UILabel = {
        $0.textColor = Color.blue
        $0.font = UIFont.systemFont(ofSize: 50)
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.lineBreakMode = .byTruncatingTail
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let viewsStackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 5
        $0.isUserInteractionEnabled = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    private let infoLabel: UILabel = {
        $0.textColor = Color.blueDark
        $0.font = UIFont.systemFont(ofSize: 45)
        $0.text = "VOTES"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.lineBreakMode = .byTruncatingTail
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let okImageView: UIImageView = {
        $0.backgroundColor = Color.clear
        $0.image = #imageLiteral(resourceName: "Up")
        $0.tintColor = Color.black
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private let okLabel: UILabel = {
        $0.textColor = Color.green
        $0.font = UIFont.systemFont(ofSize: 40)
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.lineBreakMode = .byTruncatingTail
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let okStackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 5
        $0.isUserInteractionEnabled = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    private let badImageView: UIImageView = {
        $0.backgroundColor = Color.clear
        $0.image = #imageLiteral(resourceName: "down")
        $0.tintColor = Color.black
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private let badLabel: UILabel = {
        $0.textColor = Color.red
        $0.font = UIFont.systemFont(ofSize: 40)
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.lineBreakMode = .byTruncatingTail
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let badStackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 5
        $0.isUserInteractionEnabled = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
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
    
    // MARK: - Actions
    
    // MARK: - Helpers
    
    func setup(model: Event) {
        
        if let iconName = model.iconName {
            evnetImageView.image = UIImage(named: iconName)
        }
        desLabel.text = model.name
        okLabel.text = "\(model.yes)"
        badLabel.text = "\(model.no)"
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        self.backgroundColor = Color.clear
        addSubview(bcgView)
        topStackView.addArrangedSubview(evnetImageView)
        topStackView.addArrangedSubview(desLabel)
        //viewsStackView.addArrangedSubview(nrLabel)
        //viewsStackView.addArrangedSubview(iconImageView)
        addSubview(topStackView)
        //addSubview(viewsStackView)
        //addSubview(infoLabel)
        okStackView.addArrangedSubview(okImageView)
        okStackView.addArrangedSubview(okLabel)
        badStackView.addArrangedSubview(badImageView)
        badStackView.addArrangedSubview(badLabel)
        votesStackView.addArrangedSubview(okStackView)
        votesStackView.addArrangedSubview(badStackView)
        addSubview(votesStackView)
        setupBcgView()
        setupEventImageView()
        setupOkBadImageVIews()
//        setupIconImageView()
        setupTopStackView()
        //setupViewsStackView()
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
    
//    private func setupIconImageView() {
//        iconImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
//        iconImageView.heightAnchor.constraint(equalTo: evnetImageView.widthAnchor).isActive = true
//    }
    
    private func setupOkBadImageVIews() {
        okImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        okImageView.heightAnchor.constraint(equalTo: okImageView.widthAnchor).isActive = true
        badImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        badImageView.heightAnchor.constraint(equalTo: badImageView.widthAnchor).isActive = true
    }
    
    private func setupTopStackView() {
        topStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        topStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
//    private func setupViewsStackView() {
//        viewsStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 10).isActive = true
//        viewsStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//    }
    
    private func setupVotesStackView() {
        votesStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 15).isActive = true
        votesStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
