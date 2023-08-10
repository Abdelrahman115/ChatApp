//
//  NewConversationViewController.swift
//  ChatApp
//
//  Created by Abdelrahman on 23/07/2023.
//

import UIKit
import JGProgressHUD

class NewConversationViewController: UIViewController {
    
    let spinner = JGProgressHUD(style: .dark)
    
    private let searchBar:UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.placeholder = "Search for Users"
        return searchBar
    }()
    
    let tableView:UITableView = {
       let tableView = UITableView()
        //tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    private let noUsersFoundLabel:UILabel = {
       let label = UILabel()
        label.text = "No Users Found"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 20)
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addFrames()
    }

    private func setupUI(){
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(noUsersFoundLabel)
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        searchBar.becomeFirstResponder()
    }
    
    private func addFrames(){
        tableView.frame = view.bounds
        let size = CGSize(width: 200, height: 50)
        let origin = CGPoint(x: view.center.x - size.width/2, y: view.center.y - size.height/2)
        noUsersFoundLabel.frame = CGRect(origin: origin, size: size)

    }
    
    @objc private func dismissSelf(){
        dismiss(animated: true)
    }
}


extension NewConversationViewController:UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}


extension NewConversationViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}

