//
//  EventViewController.swift
//  AngryStudent
//
//  Created by Mateusz Orzoł on 13.01.2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


fileprivate let detailsSegue: String = "show_details"


class EventViewController: BasicViewController {
    
    // MARK: - Properties
    
    let viewModel = EventViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Outlets
    
    lazy var tableView: UITableView = {
        $0.separatorStyle = .none
        $0.register(EventTableViewCell.self, forCellReuseIdentifier: String(describing: EventTableViewCell.self))
        $0.delegate = self
        $0.dataSource = self
        $0.tableFooterView = UIView()
        $0.rowHeight = 70
        $0.backgroundColor = Color.clear
        $0.showsVerticalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITableView())
    
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
        navTitle = "Events"
        bindTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.startGettingEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopGettingEvents()
    }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let identifier: String = segue.identifier ?? ""
    switch identifier {
    case detailsSegue:
      let dest: EventDetailsViewController = segue.destination as! EventDetailsViewController
      dest.event = sender as! Event
    default:
      break
    }
  }
    
    // MARK: - Binding
    
    private func bindTableView() {
        viewModel.events.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - UI
    
    private func setupUI() {
        self.view.backgroundColor = Color.white
        self.view.addSubview(tableView)
        tableView.separatorStyle = .singleLine
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 5).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }
}


extension EventViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.events.value[section].1.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.events.value.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = EventTableViewHeader()
        headerView.setup(with: viewModel.events.value[section].header)
        return headerView
    }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    performSegue(withIdentifier: detailsSegue, sender: viewModel.events.value[indexPath.section].1[indexPath.row])
  }
  
  
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EventTableViewCell.self), for: indexPath) as! EventTableViewCell
        let cellModel = viewModel.events.value[indexPath.section].1[indexPath.row]
        cell.setup(model: cellModel)
        return cell
    }
}
