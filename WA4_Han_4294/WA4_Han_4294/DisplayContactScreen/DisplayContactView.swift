//
//  DisplayContactView.swift
//  WA4_Han_4294
//
//  Created by Xinyue Han on 10/6/24.
//

import UIKit

class DisplayContactView: UIView {
    
    var nameLabel: UILabel!
    var emailLabel: UILabel!
    var phoneLabel: UILabel!
    var addressTextLabel: UILabel!
    var addressLabel: UILabel!
    var cityStateLabel: UILabel!
    var zipLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //setting the background color...
        self.backgroundColor = .white
        
        setupNameLabel()
        setupEmailLabel()
        setupPhoneLabel()
        setupAddressTextLabel()
        setupAddressLabel()
        setupCityStateLabel()
        setupZipLabel()
        
        initConstraints()
    }
    
    func setupNameLabel() {
        nameLabel = UILabel()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 26)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLabel)
    }
    
    func setupEmailLabel() {
        emailLabel = UILabel()
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(emailLabel)
    }
    
    func setupPhoneLabel() {
        phoneLabel = UILabel()
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(phoneLabel)
    }
    
    func setupAddressTextLabel() {
        addressTextLabel = UILabel()
        addressTextLabel.text = "Address:"
        addressTextLabel.font = UIFont.boldSystemFont(ofSize: 20)
        addressTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addressTextLabel)
    }
    
    func setupAddressLabel() {
        addressLabel = UILabel()
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addressLabel)
    }
    
    func setupCityStateLabel() {
        cityStateLabel = UILabel()
        cityStateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(cityStateLabel)
    }
    
    func setupZipLabel() {
        zipLabel = UILabel()
        zipLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(zipLabel)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            
            nameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            nameLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 18),
            emailLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            phoneLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 16),
            phoneLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            addressTextLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 16),
            addressTextLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            addressLabel.topAnchor.constraint(equalTo: addressTextLabel.bottomAnchor, constant: 14),
            addressLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            cityStateLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 14),
            cityStateLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            zipLabel.topAnchor.constraint(equalTo: cityStateLabel.bottomAnchor, constant: 14),
            zipLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
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
