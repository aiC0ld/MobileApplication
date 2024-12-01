//
//  MainScreenView.swift
//  App10
//
//  Created by Sakib Miazi on 5/25/23.
//

import UIKit

class MainScreenView: UIView {

    //MARK: tableView for contacts...
    var tableViewNotes: UITableView!
    
    //MARK: bottom view for adding a Contact...
    var bottomAddView:UIView!
    var textViewAddNote: UITextView!
    var buttonAdd:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupTableViewContacts()
        setupBottomAddView()
        setupTextViewAddNote()
        setupButtonAdd()
        
        initConstraints()
    }
    
    //MARK: the table view to show the list of contacts...
    func setupTableViewContacts(){
        tableViewNotes = UITableView()
        tableViewNotes.register(NotesTableViewCell.self, forCellReuseIdentifier: "notes")
        tableViewNotes.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewNotes)
    }
    
    //MARK: the bottom add contact view....
    func setupBottomAddView(){
        bottomAddView = UIView()
        bottomAddView.backgroundColor = .white
        bottomAddView.layer.cornerRadius = 6
        bottomAddView.layer.shadowColor = UIColor.lightGray.cgColor
        bottomAddView.layer.shadowOffset = .zero
        bottomAddView.layer.shadowRadius = 4.0
        bottomAddView.layer.shadowOpacity = 0.7
        bottomAddView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomAddView)
    }
    
    func setupTextViewAddNote() {
        textViewAddNote = UITextView()
        textViewAddNote.layer.borderColor = UIColor.gray.cgColor
        textViewAddNote.layer.borderWidth = 1.0
        textViewAddNote.layer.cornerRadius = 8.0
        textViewAddNote.font = UIFont.systemFont(ofSize: 16)
        textViewAddNote.translatesAutoresizingMaskIntoConstraints = false
        bottomAddView.addSubview(textViewAddNote)
    }
    
    func setupButtonAdd(){
        buttonAdd = UIButton(type: .system)
        buttonAdd.titleLabel?.font = .boldSystemFont(ofSize: 16)
        buttonAdd.setTitle("Save", for: .normal)
        buttonAdd.translatesAutoresizingMaskIntoConstraints = false
        bottomAddView.addSubview(buttonAdd)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            //bottom add view...
            bottomAddView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,constant: -8),
            bottomAddView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            bottomAddView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            buttonAdd.bottomAnchor.constraint(equalTo: bottomAddView.bottomAnchor, constant: -8),
            buttonAdd.leadingAnchor.constraint(equalTo: bottomAddView.leadingAnchor, constant: 4),
            buttonAdd.trailingAnchor.constraint(equalTo: bottomAddView.trailingAnchor, constant: -4),
            
            textViewAddNote.bottomAnchor.constraint(equalTo: buttonAdd.topAnchor, constant: -8),
            textViewAddNote.leadingAnchor.constraint(equalTo: bottomAddView.leadingAnchor, constant: 8),
            textViewAddNote.trailingAnchor.constraint(equalTo: bottomAddView.trailingAnchor, constant: -8),
            textViewAddNote.topAnchor.constraint(equalTo: bottomAddView.topAnchor, constant: 8),
            textViewAddNote.heightAnchor.constraint(lessThanOrEqualToConstant: 80),
            
            bottomAddView.topAnchor.constraint(equalTo: textViewAddNote.topAnchor, constant: -8),
            
            tableViewNotes.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            tableViewNotes.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableViewNotes.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            tableViewNotes.bottomAnchor.constraint(equalTo: bottomAddView.topAnchor, constant: -8),
        ])
    }
    
    
    //MARK: initializing constraints...
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
