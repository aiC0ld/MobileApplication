//
//  NoteScreenView.swift
//  App10
//
//  Created by Xinyue Han on 11/3/24.
//

import UIKit

class NoteScreenView: UIView {
    
    var contentWrapper: UIScrollView!
    var labelNoteText: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        setupContentWrapper()
        setupLabelNoteText()
        initConstraints()
    }
    
    func setupContentWrapper() {
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
    }
    
    func setupLabelNoteText() {
        labelNoteText = UILabel()
        labelNoteText.font = UIFont.systemFont(ofSize: 16)
        labelNoteText.numberOfLines = 0
        labelNoteText.textAlignment = .left
        labelNoteText.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelNoteText)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            contentWrapper.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            contentWrapper.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            contentWrapper.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            labelNoteText.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: 50),
            labelNoteText.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 20),
            labelNoteText.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor, constant: -20),
            labelNoteText.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor, constant: -20),
            labelNoteText.widthAnchor.constraint(equalTo: contentWrapper.widthAnchor, constant: -40)
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
