//
//  EditScreenView.swift
//  App10
//
//  Created by Xinyue Han on 10/23/24.
//

import UIKit

class EditScreenView: UIView {
    
    var contentWrapper: UIScrollView!
    
    var nameLabel: UILabel!
    var emailLabel: UILabel!
    var phoneLabel: UILabel!

    var nameTextField: UITextField!
    var emailTextField: UITextField!
    var phoneNumberTextField: UITextField!
    
    var buttonSave: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        setupContentWrapper()
        
        setupNameLabel()
        setupEmailLabel()
        setupPhoneLabel()
        
        setupNameTextField()
        setupEmailTextField()
        setupPhoneNumberTextField()
        
        setupButtonSave()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupNameLabel() {
        nameLabel = UILabel()
        nameLabel.text = "Name"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(nameLabel)
    }
    
    func setupEmailLabel() {
        emailLabel = UILabel()
        emailLabel.text = "Email"
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(emailLabel)
    }
    
    func setupPhoneLabel() {
        phoneLabel = UILabel()
        phoneLabel.text = "Phone"
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(phoneLabel)
    }
    
    func setupContentWrapper() {
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
    }
    
    func setupButtonSave() {
        buttonSave = UIButton(type: .system)
        buttonSave.setTitle("Save", for: .normal)
        buttonSave.setTitleColor(.systemBlue, for: .normal)
        buttonSave.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(buttonSave)
    }
    
    func setupNameTextField() {
        nameTextField = UITextField()
        nameTextField.placeholder = "Name"
        nameTextField.borderStyle = .roundedRect
        nameTextField.keyboardType = .namePhonePad
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(nameTextField)
    }
    
    func setupEmailTextField() {
        emailTextField = UITextField()
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.keyboardType = .emailAddress
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(emailTextField)
    }
    
    func setupPhoneNumberTextField() {
        phoneNumberTextField = UITextField()
        phoneNumberTextField.placeholder = "Phone"
        phoneNumberTextField.borderStyle = .roundedRect
        phoneNumberTextField.keyboardType = .phonePad
        phoneNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(phoneNumberTextField)
    }
    
    func initConstraints () {
        let contentLayoutGuide = contentWrapper.contentLayoutGuide
        NSLayoutConstraint.activate([
            contentWrapper.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            contentWrapper.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor),
            contentWrapper.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: 36),
            nameLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            nameLabel.widthAnchor.constraint(equalToConstant: 60),
            
            nameTextField.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 36),
            emailLabel.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 24),
            emailLabel.widthAnchor.constraint(equalToConstant: 60),
            
            emailTextField.centerYAnchor.constraint(equalTo: emailLabel.centerYAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: emailLabel.trailingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            
            phoneLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 36),
            phoneLabel.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 24),
            phoneLabel.widthAnchor.constraint(equalToConstant: 60),
            
            phoneNumberTextField.centerYAnchor.constraint(equalTo: phoneLabel.centerYAnchor),
            phoneNumberTextField.leadingAnchor.constraint(equalTo: phoneLabel.trailingAnchor),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            
            buttonSave.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 36),
            buttonSave.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            contentLayoutGuide.bottomAnchor.constraint(equalTo: buttonSave.bottomAnchor),
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
