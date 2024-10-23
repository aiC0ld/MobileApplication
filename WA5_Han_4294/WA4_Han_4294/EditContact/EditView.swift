//
//  EditView.swift
//  WA4_Han_4294
//
//  Created by Xinyue Han on 10/13/24.
//

import UIKit

class EditView: UIView {

    var nameTextField: UITextField!
    var emailTextField: UITextField!
    var phoneNumberTextField: UITextField!
    var addressTextField: UITextField!
    var cityStateTextField: UITextField!
    var zipTextField: UITextField!

    var buttonTakePhoto: UIButton!
    var photoLabel: UILabel!;
    var buttonSelectPhoneType: UIButton!
    var buttonSave: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        setupNameTextField()
        setupEmailTextField()
        setupPhoneNumberTextField()
        setupAddressTextField()
        setupCityStateTextField()
        setupZipTextField()
        
        setupButtonSelectPhoneType()
        setupButtonTakePhoto()
        setupButtonSave()
        setupPhotoLabel()
        
        initConstraints()
    }
    
    func setupButtonSelectPhoneType() {
        buttonSelectPhoneType = UIButton(type: .system)
        buttonSelectPhoneType.setTitle("Home", for: .normal)
        buttonSelectPhoneType.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonSelectPhoneType)
    }
    
    func setupButtonTakePhoto() {
        buttonTakePhoto = UIButton(type: .system)
        buttonTakePhoto.setTitle("", for: .normal)
        buttonTakePhoto.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        buttonTakePhoto.contentHorizontalAlignment = .fill
        buttonTakePhoto.contentVerticalAlignment = .fill
        buttonTakePhoto.imageView?.contentMode = .scaleAspectFit
        buttonTakePhoto.showsMenuAsPrimaryAction = true
        buttonTakePhoto.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonTakePhoto)
    }
    
    func setupButtonSave() {
        buttonSave = UIButton(type: .system)
        buttonSave.setTitle("Save", for: .normal)
        buttonSave.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonSave)
    }
    
    func setupPhotoLabel() {
        photoLabel = UILabel()
        photoLabel.text = "Photo"
        photoLabel.font = photoLabel.font.withSize(20)
        photoLabel.textColor = UIColor.gray
        photoLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(photoLabel)
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
            
//            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
//            titleLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
        
            nameTextField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            nameTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            nameTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            
            buttonTakePhoto.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            buttonTakePhoto.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            buttonTakePhoto.widthAnchor.constraint(equalToConstant: 100),
            buttonTakePhoto.heightAnchor.constraint(equalToConstant: 100),
            
            photoLabel.topAnchor.constraint(equalTo: buttonTakePhoto.bottomAnchor, constant: 1),
            photoLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),

            emailTextField.topAnchor.constraint(equalTo: photoLabel.bottomAnchor, constant: 16),
            emailTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            
            buttonSelectPhoneType.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            buttonSelectPhoneType.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            buttonSelectPhoneType.widthAnchor.constraint(equalToConstant: 80),
            
            phoneNumberTextField.centerYAnchor.constraint(equalTo: buttonSelectPhoneType.centerYAnchor),
            phoneNumberTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: buttonSelectPhoneType.leadingAnchor, constant: -8),

//            phoneNumberTextField.topAnchor.constraint(equalTo: phonePicker.bottomAnchor, constant: -16),
//            phoneNumberTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24),
//            phoneNumberTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24),

            addressTextField.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 16),
            addressTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            addressTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24),

            cityStateTextField.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 16),
            cityStateTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            cityStateTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24),

            zipTextField.topAnchor.constraint(equalTo: cityStateTextField.bottomAnchor, constant: 16),
            zipTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            zipTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            
            buttonSave.topAnchor.constraint(equalTo: zipTextField.bottomAnchor, constant: 32),
            buttonSave.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
