//
//  OwnerVotesViewController.swift
//  AngryStudent
//
//  Created by Mateusz Orzoł on 13.01.2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class OwnerVotesViewController: BasicViewController {
    
    // MARK: - Properties
    
    let viewModel = OwnerVotesViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Outlets
    
    let ownerView: OwnerVotesView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(OwnerVotesView())
    
    
    // MARK: - Actions
    
    private func deleteEvent(with model: Event) {
        
    }
    
    private func leaveEvent(with model: Event) {
        
    }

    // MARK: - Initialization
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindView()
    }
    
    // MARK: - Binding
    
    private func bindView() {
        viewModel.event.asObservable().subscribe(onNext: { [weak self] (event) in
            guard let event = event else { return }
            self?.ownerView.setup(model: event)
            self?.navigationController?.title = event.name
        }).disposed(by: disposeBag)
    }
    
    // MARK: - UI
    
    private func setupUI() {
        self.view.backgroundColor = Color.white
        self.view.addSubview(ownerView)
        setupOwnerView()
    }
    
    private func setupOwnerView() {
        ownerView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 5).isActive = true
        ownerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true
        ownerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        ownerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }
}
