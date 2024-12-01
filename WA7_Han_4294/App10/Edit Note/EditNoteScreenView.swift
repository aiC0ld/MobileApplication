//
//  EditNoteScreenView.swift
//  App10
//
//  Created by Xinyue Han on 11/3/24.
//

import UIKit

class EditNoteScreenView: UIView {
    
    var tableViewNotes: UITableView!
    
    //MARK: bottom view for adding a Contact...
    var bottomAddView:UIView!
    var textFieldNote: UITextView!
    var buttonSave:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupTableViewNotes()
        
        setupBottomAddView()
        setupTextViewAddNote()
        setupButtonAdd()
        
        initConstraints()
    }
    
    func setupTableViewNotes(){
        tableViewNotes = UITableView()
        tableViewNotes.register(NotesTableViewCell.self, forCellReuseIdentifier: "notes")
        tableViewNotes.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewNotes)
    }
    
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
        textFieldNote = UITextView()
        textFieldNote.layer.borderColor = UIColor.gray.cgColor
        textFieldNote.layer.borderWidth = 1.0
        textFieldNote.layer.cornerRadius = 8.0
        textFieldNote.font = UIFont.systemFont(ofSize: 16)
        textFieldNote.translatesAutoresizingMaskIntoConstraints = false
        bottomAddView.addSubview(textFieldNote)
    }
    
    func setupButtonAdd(){
        buttonSave = UIButton(type: .system)
        buttonSave.titleLabel?.font = .boldSystemFont(ofSize: 16)
        buttonSave.setTitle("Save", for: .normal)
        buttonSave.translatesAutoresizingMaskIntoConstraints = false
        bottomAddView.addSubview(buttonSave)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            bottomAddView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,constant: -8),
            bottomAddView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            bottomAddView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            buttonSave.bottomAnchor.constraint(equalTo: bottomAddView.bottomAnchor, constant: -8),
            buttonSave.leadingAnchor.constraint(equalTo: bottomAddView.leadingAnchor, constant: 4),
            buttonSave.trailingAnchor.constraint(equalTo: bottomAddView.trailingAnchor, constant: -4),
            

            textFieldNote.bottomAnchor.constraint(equalTo: buttonSave.topAnchor, constant: -8),
            textFieldNote.leadingAnchor.constraint(equalTo: bottomAddView.leadingAnchor, constant: 8),
            textFieldNote.trailingAnchor.constraint(equalTo: bottomAddView.trailingAnchor, constant: -8),
            textFieldNote.topAnchor.constraint(equalTo: bottomAddView.topAnchor, constant: 8),
            textFieldNote.heightAnchor.constraint(lessThanOrEqualToConstant: 1200),
                        
            tableViewNotes.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            tableViewNotes.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableViewNotes.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            tableViewNotes.bottomAnchor.constraint(equalTo: bottomAddView.topAnchor, constant: -8),
            
            bottomAddView.topAnchor.constraint(equalTo: textFieldNote.topAnchor, constant: -8),
            
        ])
    }
    
    
    //MARK: initializing constraints...
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
