import Foundation
import UIKit
import RxSwift


class FriendsViewController: BasicViewController {
    
    // MARK: - Properties
    
    let viewModel = FriendsViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Outlets
    
    lazy var tableView: UITableView = {
        $0.separatorStyle = .none
        $0.register(FriendsTableViewCell.self, forCellReuseIdentifier: String(describing: FriendsTableViewCell.self))
        $0.delegate = self
        $0.dataSource = self
        $0.tableFooterView = UIView()
        $0.rowHeight = 90
        $0.backgroundColor = Color.clear
        $0.showsVerticalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITableView())
    
    // MARK: - Actions
    
    // MARK: - Initialization
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.navTitle = "Friends"
    }
    
    // MARK: - Binding
    
    private func bindTableView() {
        viewModel.friends.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - UI
    
    private func setupUI() {
        self.view.backgroundColor = Color.white
        self.view.addSubview(tableView)
        tableView.separatorStyle = .none
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 5).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }
}


extension FriendsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.friends.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FriendsTableViewCell.self), for: indexPath) as! FriendsTableViewCell
        let cellModel = viewModel.friends.value[indexPath.row]
        cell.setup(model: cellModel)
        return cell
    }
}
