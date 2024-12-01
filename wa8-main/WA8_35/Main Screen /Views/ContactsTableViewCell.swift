//
//  ContactsTableViewCell.swift
//  WA8_35
//
//  Created by Yu huiying on 11/8/24.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    
    var wrapperCellView: UIView!
    var labelName: UILabel!
    var labelEmail: UILabel!
    var labelMessage: UILabel!
    var labelTime: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupLabelName()
        setupLabelEmail()
        setupLabelMessage()
        setupLabelTime()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWrapperCellView(){
        wrapperCellView = UITableViewCell()
        
        //working with the shadows and colors...
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 6.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 4.0
        wrapperCellView.layer.shadowOpacity = 0.4
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupLabelName(){
        labelName = UILabel()
        labelName.font = UIFont.boldSystemFont(ofSize: 20)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelName)
    }
    
    func setupLabelEmail(){
        labelEmail = UILabel()
        labelEmail.font = UIFont.boldSystemFont(ofSize: 14)
        labelEmail.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelEmail)
    }
    
    func setupLabelMessage() {
        labelMessage = UILabel()
        labelMessage.text = "Message"
        labelMessage.font = UIFont.systemFont(ofSize: 14)
        labelMessage.textColor = .darkGray
        labelMessage.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelMessage)
    }
    
    func setupLabelTime() {
        labelTime = UILabel()
        labelTime.font = UIFont.systemFont(ofSize: 12)
        labelTime.textColor = .lightGray
        labelTime.textAlignment = .right
        labelTime.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelTime)
    }
    
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            labelName.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            labelName.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            labelName.heightAnchor.constraint(equalToConstant: 20),
            labelName.widthAnchor.constraint(lessThanOrEqualTo: wrapperCellView.widthAnchor),
            
            labelEmail.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 2),
            labelEmail.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            labelEmail.heightAnchor.constraint(equalToConstant: 16),
            labelEmail.widthAnchor.constraint(lessThanOrEqualTo: labelName.widthAnchor),
            
            labelTime.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            labelTime.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -16),
            
            labelMessage.topAnchor.constraint(equalTo: labelEmail.bottomAnchor, constant: 0),
            labelMessage.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            labelMessage.heightAnchor.constraint(equalToConstant: 16),
            labelMessage.widthAnchor.constraint(lessThanOrEqualTo: labelName.widthAnchor),
            
            wrapperCellView.heightAnchor.constraint(equalToConstant: 72)
        ])
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
