//
//  DetailScreenView.swift
//  App10
//
//  Created by Xinyue Han on 11/3/24.
//

import UIKit

class DetailScreenView: UIView {
    
    var contentWrapper:UIScrollView!
    var labelName: UILabel!
    var labelEmail: UILabel!
    var labelId: UILabel!
    var buttonLogOut: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white

        setupContentWrapper()
        setupLabelName()
        setupLabelEmail()
        setupLabelId()
        setupButtonLogOut()

        initConstraints()
    }

    // Initialize the UI elements for displaying profile information
    func setupContentWrapper(){
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
    }
    
    func setupLabelName() {
        labelName = UILabel()
        labelName.font = UIFont.boldSystemFont(ofSize: 30)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelName)
    }

    func setupLabelEmail() {
        labelEmail = UILabel()
        labelEmail.font = labelEmail.font.withSize(20)
        labelEmail.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelEmail)
    }

    func setupLabelId() {
        labelId = UILabel()
        labelId.font = labelId.font.withSize(20)
        labelId.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelId)
    }
    
    func setupButtonLogOut() {
        buttonLogOut = UIButton(type: .system)
        buttonLogOut.setTitle("Log out", for: .normal)
        buttonLogOut.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        buttonLogOut.setTitleColor(.systemBlue, for: .normal)
        buttonLogOut.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(buttonLogOut)
    }
    
   
    // Initialize constraints for displaying profile information labels
    func initConstraints() {
        NSLayoutConstraint.activate([
            contentWrapper.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            contentWrapper.widthAnchor.constraint(equalTo:self.safeAreaLayoutGuide.widthAnchor),
            contentWrapper.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor),
            
            labelName.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: 20),
            labelName.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
    
            labelEmail.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 20),
            labelEmail.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),

            labelId.topAnchor.constraint(equalTo: labelEmail.bottomAnchor, constant: 16),
            labelId.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            buttonLogOut.topAnchor.constraint(equalTo: labelId.bottomAnchor, constant: 30),
            buttonLogOut.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            buttonLogOut.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor, constant: -20)
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
