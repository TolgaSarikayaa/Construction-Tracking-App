//
//  ProfilViewController.swift
//  Red
//
//  Created by Tolga Sarikaya on 16.08.23.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseDatabase
import SDWebImage

class ProfilViewController: UIViewController {
    var collectionProjects = Firestore.firestore()
    var userList = [User]()
    var viewModel = ProfilViewModel()
    
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    private let userName: UILabel = {
        let label = UILabel()
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.textAlignment = .left
        return label
    }()
    
    private let company: UILabel = {
        let label = UILabel()
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.textAlignment = .left
        return label
    }()
    
    private let email: UILabel = {
        let label = UILabel()
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.textAlignment = .left
        return label
    }()
    
    
    
    private let logOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log Out", for: .normal)
        button.layer.cornerRadius = 12
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        viewModel.userList.subscribe { [weak self] userList in
            guard let self = self else { return }

           
                for user in userList {
                  
                        self.imageView.sd_setImage(with: URL(string: user.profileImageURL!), completed: nil)
                        self.userName.text = "User: \(user.username!)"
                        self.company.text = "Company: \(user.company!)"
                        self.email.text = "Email: \(user.email!)"
                       
                    }
                
            }
        
           

        logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
        
        view.addSubview(scrollView)
       
        scrollView.addSubview(userName)
        scrollView.addSubview(company)
        scrollView.addSubview(email)
        scrollView.addSubview(imageView)
        scrollView.addSubview(logOutButton)
        
    }
    
   
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        
        imageView.frame = CGRect(x: (scrollView.width-size)/2, y: 120, width: size, height: size)
        imageView.layer.cornerRadius = imageView.width/2.0
        userName.frame = CGRect(x: 30, y: imageView.bottom+20, width: scrollView.width-60, height: 52)
        company.frame = CGRect(x: 30, y: userName.bottom+20, width: scrollView.width-60, height: 52)
        email.frame = CGRect(x: 30, y: company.bottom+20, width: scrollView.width-60, height: 52)
        logOutButton.frame = CGRect(x: 30, y: email.bottom+20, width: scrollView.width-60, height: 52)
    }
    
    func updateUserInformation(user: User) {
        self.imageView.sd_setImage(with: URL(string: user.profileImageURL!), completed: nil)
        self.userName.text = "User: \(user.username!)"
        self.company.text = "Company: \(user.company!)"
        self.email.text = "Email: \(user.email!)"
    }
    
   
    

    
    // MARK: - Actions
    @objc func logOutButtonTapped() {
        do {
            try Auth.auth().signOut()
            viewModel.userRepo.userList.onCompleted()
             userList = []
            self.performSegue(withIdentifier: "toLoginVC", sender: nil)
        } catch {
            print("Error")
        }
    }
}
