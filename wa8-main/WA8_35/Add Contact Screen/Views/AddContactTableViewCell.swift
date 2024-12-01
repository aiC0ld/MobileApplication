//
//  AddContactTableViewCell.swift
//  WA8_35
//
//  Created by Yu huiying on 11/8/24.
//

import UIKit

class AddContactTableViewCell: UITableViewCell {
    var wrapperCellView: UIView!
    var labelUser: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupNameLabel()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupWrapperCellView() {
        wrapperCellView = UIView()
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 6.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 6.0
        wrapperCellView.layer.shadowOpacity = 0.6
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(wrapperCellView)
    }
    
    private func setupNameLabel() {
        labelUser = UILabel()
        labelUser.font = UIFont.boldSystemFont(ofSize: 20)
        labelUser.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelUser)
    }
    
    private func initConstraints() {
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            wrapperCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            wrapperCellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            wrapperCellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            labelUser.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            labelUser.centerYAnchor.constraint(equalTo: wrapperCellView.centerYAnchor),
            labelUser.trailingAnchor.constraint(lessThanOrEqualTo: wrapperCellView.trailingAnchor, constant: -16),
            
            wrapperCellView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
