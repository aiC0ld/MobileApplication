//
//  MainScreenView.swift
//  FinalProject_35
//
//  Created by Yu huiying on 11/28/24.
//

import UIKit

class MainScreenView: UIView {
    var searchBar: UISearchBar!
    var tableView: UITableView!
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupSearchBar()
        setupTableView()
        setupTitleLabel()
        initConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSearchBar() {
        //MARK: Search Bar...
        searchBar = UISearchBar()
        searchBar.placeholder = "Search posts.."
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundImage = UIImage()
        self.addSubview(searchBar)
    }
    
    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "ExploreHub"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "postCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 220
        tableView.separatorStyle = .none
        self.addSubview(tableView)
    }
    
    private func initConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: -20),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
