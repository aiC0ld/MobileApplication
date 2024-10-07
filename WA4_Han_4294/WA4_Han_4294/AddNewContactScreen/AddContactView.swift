//
//  AddContactView.swift
//  WA4_Han_4294
//
//  Created by Xinyue Han on 10/6/24.
//

import UIKit

class AddContactView: UIView {
    
    var titleLabel: UILabel!
    var nameTextField: UITextField!
    var emailTextField: UITextField!
    var addPhoneLabel: UILabel!
    var phonePicker: UIPickerView!
    var phoneNumberTextField: UITextField!
    var addressTextField: UITextField!
    var cityStateTextField: UITextField!
    var zipTextField: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        setupTitleLabel()
        setupNameTextField()
        setupEmailTextField()
        setupAddPhoneLabel()
        setupPhonePicker()
        setupPhoneNumberTextField()
        setupAddressTextField()
        setupCityStateTextField()
        setupZipTextField()
        initConstraints()
    }
    
    func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "Add a New Contact"
        titleLabel.font = titleLabel.font.withSize(26)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
    }
    
    func setupNameTextField() {
        nameTextField = UITextField()
        nameTextField.placeholder = "Name"
        nameTextField.borderStyle = .roundedRect
        nameTextField.keyboardType = .namePhonePad
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameTextField)
    }
    
    func setupEmailTextField() {
        emailTextField = UITextField()
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.keyboardType = .emailAddress
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(emailTextField)
    }
    
    func setupAddPhoneLabel() {
        addPhoneLabel = UILabel()
        addPhoneLabel.text = "Add Phone"
        addPhoneLabel.font = addPhoneLabel.font.withSize(22)
        addPhoneLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addPhoneLabel)
    }
    
    func setupPhonePicker() {
        phonePicker = UIPickerView()
        phonePicker.isUserInteractionEnabled = true
        phonePicker.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(phonePicker)
    }
    
    func setupPhoneNumberTextField() {
        phoneNumberTextField = UITextField()
        phoneNumberTextField.placeholder = "Phone number"
        phoneNumberTextField.borderStyle = .roundedRect
        phoneNumberTextField.keyboardType = .phonePad
        phoneNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(phoneNumberTextField)
    }
    
    func setupAddressTextField() {
        addressTextField = UITextField()
        addressTextField.placeholder = "Address"
        addressTextField.borderStyle = .roundedRect
        addressTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addressTextField)
    }
    
    func setupCityStateTextField() {
        cityStateTextField = UITextField()
        cityStateTextField.placeholder = "City, State"
        cityStateTextField.borderStyle = .roundedRect
        cityStateTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(cityStateTextField)
    }
    
    func setupZipTextField() {
        zipTextField = UITextField()
        zipTextField.placeholder = "ZIP"
        zipTextField.borderStyle = .roundedRect
        zipTextField.keyboardType = .numberPad
        zipTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(zipTextField)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
        
            nameTextField.topAnchor.constraint(equalTo: titleLabel.safeAreaLayoutGuide.topAnchor, constant: 32),
            nameTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            nameTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24),

            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            emailTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24),

            addPhoneLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            addPhoneLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),

            phonePicker.topAnchor.constraint(equalTo: addPhoneLabel.bottomAnchor, constant: -50),
            phonePicker.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),

            phoneNumberTextField.topAnchor.constraint(equalTo: phonePicker.bottomAnchor, constant: -16),
            phoneNumberTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24),

            addressTextField.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 16),
            addressTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            addressTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24),

            cityStateTextField.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 16),
            cityStateTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            cityStateTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24),

            zipTextField.topAnchor.constraint(equalTo: cityStateTextField.bottomAnchor, constant: 16),
            zipTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            zipTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24),
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
