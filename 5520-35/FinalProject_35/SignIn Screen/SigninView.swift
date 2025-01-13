//
//  SigninView.swift
//  FinalProject_35
//
//  Created by Xinyue Han on 12/1/24.
//

import UIKit

class SigninView: UIView {
    
    var titleLabel: UILabel!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var signinButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupTitleLabel()
        setupEmailTextField()
        setupPasswordTextField()
        setupSigninButton()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "ExploreHub"
        titleLabel.font = .boldSystemFont(ofSize: 36)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
    }
    
    func setupEmailTextField() {
        emailTextField = UITextField()
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.autocapitalizationType = .none
        emailTextField.keyboardType = .emailAddress
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(emailTextField)
    }
    
    func setupPasswordTextField() {
        passwordTextField = UITextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(passwordTextField)
    }
    
    func setupSigninButton() {
        signinButton = UIButton(type: .system)
        signinButton.setTitle("Sign in", for: .normal)
        signinButton.setTitleColor(.white, for: .normal)
        signinButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        signinButton.backgroundColor = .darkGray
        signinButton.layer.cornerRadius = 10
        signinButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(signinButton)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Title Label Constraints
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50),
            
            // Email Text Field Constraints
            emailTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            emailTextField.widthAnchor.constraint(equalToConstant: 300),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Password Text Field Constraints
            passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            
            // Login Button Constraints
            signinButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            signinButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            signinButton.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
            signinButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
