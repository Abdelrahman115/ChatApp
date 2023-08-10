//
//  ViewController.swift
//  ChatApp
//
//  Created by Abdelrahman on 23/07/2023.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class ConversationsViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    
    let tableView:UITableView = {
       let tableView = UITableView()
        //tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    private let noConversationsLabel:UILabel = {
       let label = UILabel()
        label.text = "No Conversations"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 20)
        label.isHidden = true
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //try! FirebaseAuth.Auth.auth().signOut()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapComposeButton))
        setupUI()
        fetchConversations()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
        
    }
    
    
    private func setupUI(){
        view.backgroundColor = .systemBackground
        addSubViews()
        addFrames()
    }
    
    private func addSubViews(){
        view.addSubview(tableView)
        view.addSubview(noConversationsLabel)
    }
    
    private func addFrames(){
        tableView.frame = view.bounds
        let size = CGSize(width: 200, height: 50)
        let origin = CGPoint(x: view.center.x - size.width/2, y: view.center.y - size.height/2 + 50)
        noConversationsLabel.frame = CGRect(origin: origin, size: size)
    }
    
    private func fetchConversations(){
        
    }
    
    
    @objc private func didTapComposeButton(){
        let vc = NewConversationViewController()
        let navVC = UINavigationController(rootViewController: vc)
        
        present(navVC,animated: true)
    }
    
    
    
    private func validateAuth(){
        if FirebaseAuth.Auth.auth().currentUser == nil{
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav,animated: false)
        }
    }
}


extension ConversationsViewController:UITableViewDelegate,UITableViewDataSource {
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
        
        let vc = ChatViewController()
        vc.title = "ahmed"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

