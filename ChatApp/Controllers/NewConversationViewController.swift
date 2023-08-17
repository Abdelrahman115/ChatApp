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
    private var users:[[String:String]] = []
    private var results:[[String:String]] = []
    private var hasFetched = false
    
    private var viewModel: NewConversationViewModel!
    
    private let searchVC = UISearchController(searchResultsController: nil)
    /*private let searchBar:UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.placeholder = "Search for Users"
        return searchBar
    }()*/
    
    let tableView:UITableView = {
       let tableView = UITableView()
        tableView.isHidden = true
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
        //searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        createSearchBar()
        //navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(dismissSelf))
        //searchBar.becomeFirstResponder()
    }
    
    private func createSearchBar(){
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
        searchVC.becomeFirstResponder()
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
        results.removeAll()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        results.removeAll()
        spinner.show(in: view)
        searchUsers(query: text)
    }
    
    func searchUsers(query:String){
        if hasFetched{
            filterUsers(with: query)
            self.updateUI()
            self.spinner.dismiss(animated: true)
        }else{
            viewModel = NewConversationViewModel()
            viewModel.fetchUsers()
            viewModel.bindUsersToNewConversationView = {[weak self] in
                guard let self = self else {return}
                DispatchQueue.main.async {
                    guard let users = self.viewModel.users else {return}
                    self.users.removeAll()
                    self.users.append(contentsOf: users)
                    self.results.removeAll()
                    self.filterUsers(with: query)
                    self.updateUI()
                    self.spinner.dismiss(animated: true)
                    self.hasFetched = true
                }
            }
        }
    }
    
    
    func filterUsers(with term:String){
        //guard hasFetched else {return}
        let results:[[String:String]] = self.users.filter ({
            guard let name = $0["name"]?.lowercased() as? String else {return false}
            
            return name.hasPrefix(term.lowercased())
        })
        self.results = results
    }
    
    func updateUI(){
        if results.isEmpty{
            self.noUsersFoundLabel.isHidden = false
            self.tableView.isHidden = true
        }else{
            self.tableView.isHidden = false
            self.noUsersFoundLabel.isHidden = true
            self.tableView.reloadData()
        }
    }
}


extension NewConversationViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = results[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = user["name"]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

