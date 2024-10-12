//
//  ViewController.swift
//  IntroCoreData
//
//  Created by Pedro on 10/10/24.
//

import UIKit

class ViewController: UIViewController {
    
    let viewModel: ViewModel = ViewModel()

    @IBOutlet weak var tableView: UITableView!
    
    func configure() {
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.title = "KeepCoders"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppLog.debug("Log test")
        configure()

        viewModel.status = { [weak self] status in
            if status == .loaded {
                self?.tableView.reloadData()
            }
        }
        viewModel.loadData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfKeepCoders()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let keepCoder = viewModel.keepCoder(at: indexPath.row) {
            cell.textLabel?.text = keepCoder.name
            cell.detailTextLabel?.text = keepCoder.bootcamp
        }
        
        return cell
    }
    
    
}

