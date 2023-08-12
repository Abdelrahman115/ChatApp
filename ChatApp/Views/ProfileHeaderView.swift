//
//  ProfileHeaderView.swift
//  ChatApp
//
//  Created by Abdelrahman on 12/08/2023.
//

import UIKit

class ProfileHeaderView: UIView {
    private var viewModel: ProfileViewModel!

    let imageView:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 75
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        self.backgroundColor = .secondarySystemBackground
       addSubview(imageView)
        fetchProfileImageURL(imageView: imageView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: (self.width - 150) / 2, y: 25, width: 150, height: 150)
    }
    
    
     private func fetchProfileImageURL(imageView:UIImageView){
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return }
        let safeEmail = DatabaseManager.safeEmail(email: email)
        let fileName = safeEmail + "_profile_picture.png"
        let path = "images/" + fileName
        viewModel = ProfileViewModel()
        viewModel.fetchImageURL(path: path)
        viewModel.bindImageURLtoProfileView = {[weak self] in
            DispatchQueue.main.async {
                guard let strinURL = self?.viewModel.imageURL else {return}
                let imageURL = URL(string: strinURL)
                imageView.kf.setImage(with: imageURL,placeholder: UIImage(named: "person"))
                //tableView.reloadData()
            }
        }
    }

}
