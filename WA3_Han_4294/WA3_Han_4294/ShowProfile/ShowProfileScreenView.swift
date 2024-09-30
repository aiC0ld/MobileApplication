//
//  ShowProfileScreenView.swift
//  WA3_Han_4294
//
//  Created by Xinyue Han on 9/27/24.
//

import UIKit

class ShowProfileScreenView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var nameLabel: UILabel!
    var emailLabel: UILabel!
    var phoneLabel: UILabel!
    var addressLabel: UILabel!
    var cityStateLabel: UILabel!
    var zipLabel: UILabel!
    var phoneTypeImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //setting the background color...
        self.backgroundColor = .white
        
        setupNameLabel()
        setupEmailLabel()
        setupPhoneLabel()
        setupAddressLabel()
        setupCityStateLabel()
        setupZipLabel()
        setupPhoneTypeImage()
        
        initConstraints()
    }
    
    func setupNameLabel() {
        nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLabel)
    }
    
    func setupEmailLabel() {
        emailLabel = UILabel()
        emailLabel.textAlignment = .left
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(emailLabel)
    }
    
    func setupPhoneLabel() {
        phoneLabel = UILabel()
        phoneLabel.textAlignment = .left
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(phoneLabel)
    }
    
    func setupAddressLabel() {
        addressLabel = UILabel()
        addressLabel.textAlignment = .left
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addressLabel)
    }
    
    func setupCityStateLabel() {
        cityStateLabel = UILabel()
        cityStateLabel.textAlignment = .left
        cityStateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(cityStateLabel)
    }
    
    func setupZipLabel() {
        zipLabel = UILabel()
        zipLabel.textAlignment = .left
        zipLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(zipLabel)
    }
    
    func setupPhoneTypeImage() {
        phoneTypeImage = UIImageView()
        phoneTypeImage.contentMode = .scaleAspectFit
        phoneTypeImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(phoneTypeImage)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            
            nameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            nameLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24),
        
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            emailLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            
            phoneLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 16),
            phoneLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            
            addressLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 16),
            addressLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            
            cityStateLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 16),
            cityStateLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            
            zipLabel.topAnchor.constraint(equalTo: cityStateLabel.bottomAnchor, constant: 16),
            zipLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            
            phoneTypeImage.topAnchor.constraint(equalTo: zipLabel.bottomAnchor, constant: 32),
            phoneTypeImage.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
