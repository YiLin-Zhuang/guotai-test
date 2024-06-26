//
//  NotificationViewController.swift
//  testPJ
//
//  Created by yilin on 2024/6/26.
//

import UIKit

class NotificationViewController: UIViewController {
    
    fileprivate let viewModel:NotificationViewModel
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    init(_ viewModel:NotificationViewModel) {
      self.viewModel = viewModel
      super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    fileprivate func setupUI() {
        self.navigationController?.navigationBar.isHidden = false
        self.view.backgroundColor = UIColor(white: 250.0 / 255.0, alpha: 1.0)
        self.title = "Notification"
        self.view = tableView
    }
    
    fileprivate func setupTableView() {
        self.tableView.register(NotificationTableViewCell.nib, forCellReuseIdentifier: NotificationTableViewCell.identifier)
    }

}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.identifier, for: indexPath) as? NotificationTableViewCell
        else { return UITableViewCell()}
        
        let message = viewModel.messages[indexPath.row]
        cell.setup(message)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension NotificationViewController: Routable {
  static func initWithParams(params: RouterParameter?) -> UIViewController {
    guard let viewModel = params?["viewModel"] as? NotificationViewModel else {
      fatalError("params is wrong")
    }
    let notificationViewController = NotificationViewController(viewModel)
    return notificationViewController
  }
}
