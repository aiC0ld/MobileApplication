//
//  LandingScreenView.swift
//  FinalProject_35
//
//  Created by Xinyue Han on 12/1/24.
//

import UIKit

class LandingScreenView: UIView {

    var titleLabel: UILabel!
    var signinButton: UIButton!
    var registerButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupTitleLabel()
        setupSigninButton()
        setupRegisterButton()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "ExploreHub"
        titleLabel.font = .boldSystemFont(ofSize: .init(36))
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .black
        self.addSubview(titleLabel)
    }
    
    func setupSigninButton() {
        signinButton = UIButton(type: .system)
        signinButton.setTitle("Sign in", for: .normal)
        signinButton.setTitleColor(.white, for: .normal)
        signinButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        signinButton.backgroundColor = .systemBlue
        signinButton.layer.cornerRadius = 10
        signinButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(signinButton)
    }
    
    func setupRegisterButton() {
        registerButton = UIButton(type: .system)
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        registerButton.backgroundColor = .systemGreen
        registerButton.layer.cornerRadius = 10
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(registerButton)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 100),
            
            signinButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            signinButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 80),
            signinButton.widthAnchor.constraint(equalToConstant: 220),
            signinButton.heightAnchor.constraint(equalToConstant: 60),
            
            registerButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: signinButton.bottomAnchor, constant: 30),
            registerButton.widthAnchor.constraint(equalToConstant: 220),
            registerButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
