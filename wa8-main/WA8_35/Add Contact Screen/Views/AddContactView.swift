//
//  AddContactView.swift
//  WA8_35
//
//  Created by Yu huiying on 11/8/24.
//

import UIKit

class AddContactView: UIView {
    var tableView: UITableView!
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupTableView()
        setupTitleLabel()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "Start chatting!"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.register(AddContactTableViewCell.self, forCellReuseIdentifier: "AddContactCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableView)
    }
    
    private func initConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 22),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
