//
//  DisplayScreenView.swift
//  App10
//
//  Created by Xinyue Han on 10/23/24.
//

import UIKit

class DisplayScreenView: UIView {
    
    var contentWrapper: UIScrollView!
    var nameLabel: UILabel!
    var emailLabel: UILabel!
    var phoneLabel: UILabel!
    var deleteButton: UIButton!;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupContentWrapper()
        setupNameLabel()
        setupEmailLabel()
        setupPhoneLabel()
        setDeleteButton()
        
        initConstraints()
    }
    
    func setupContentWrapper(){
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
    }
    
    func setupNameLabel(){
        nameLabel = UILabel()
        nameLabel.text = "Name"
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 20)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(nameLabel)
    }
    
    func setupEmailLabel(){
        emailLabel = UILabel()
        emailLabel.text = "Email"
        emailLabel.textAlignment = .center
        emailLabel.font = UIFont.systemFont(ofSize: 20)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(emailLabel)
    }
    
    func setupPhoneLabel(){
        phoneLabel = UILabel()
        phoneLabel.text = "Phone"
        phoneLabel.textAlignment = .center
        phoneLabel.font = UIFont.systemFont(ofSize: 20)
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(phoneLabel)
    }
    
    func setDeleteButton() {
        deleteButton = UIButton(type: .system)
        deleteButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(.systemBlue, for: .normal);
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(deleteButton)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            
            contentWrapper.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            contentWrapper.widthAnchor.constraint(equalTo:self.safeAreaLayoutGuide.widthAnchor),
            contentWrapper.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: 32),
            nameLabel.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            emailLabel.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            
            phoneLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20),
            phoneLabel.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            // TODO
//            phoneLabel.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor),
            
            deleteButton.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 16),
            deleteButton.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
