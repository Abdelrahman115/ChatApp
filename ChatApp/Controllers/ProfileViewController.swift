//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Abdelrahman on 23/07/2023.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {
    
    private var viewModel: ProfileViewModel!
    let headerView = ProfileHeaderView?.self
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewProperties()
        viewModel = ProfileViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.tableHeaderView = ProfileHeaderView()
    }
    
    
    private func tableViewProperties(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    
}

extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "Sign Out"
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.alertUserLogOut(view: self)
    }
}
