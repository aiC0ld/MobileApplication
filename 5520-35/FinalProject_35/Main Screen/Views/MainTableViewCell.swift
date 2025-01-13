//
//  MainTableViewCell.swift
//  FinalProject_35
//
//  Created by Yu huiying on 11/28/24.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    var stackView: UIStackView!
    var leftPostView: UIView!
    var rightPostView: UIView!
    var leftImageView: UIImageView!
    var rightImageView: UIImageView!
    var leftLabel: UILabel!
    var rightLabel: UILabel!

    var leftPostTapped: (() -> Void)?
    var rightPostTapped: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupStackView()
        setupPostViews()
        setupImageViews()
        setupLabels()
        addGestureRecognizers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStackView() {
        stackView = UIStackView()
        stackView.axis = .horizontal // Stack views horizontally
        stackView.spacing = 10 // Space between left and right post views
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }

    private func setupPostViews() {
        leftPostView = UIView()
        leftPostView.backgroundColor = .white
        leftPostView.layer.cornerRadius = 6.0
        leftPostView.layer.shadowColor = UIColor.gray.cgColor
        leftPostView.layer.shadowOffset = .zero
        leftPostView.layer.shadowRadius = 6.0
        leftPostView.layer.shadowOpacity = 0.6
        leftPostView.translatesAutoresizingMaskIntoConstraints = false
        
        rightPostView = UIView()
        rightPostView.backgroundColor = .white
        rightPostView.layer.cornerRadius = 6.0
        rightPostView.layer.shadowColor = UIColor.gray.cgColor
        rightPostView.layer.shadowOffset = .zero
        rightPostView.layer.shadowRadius = 6.0
        rightPostView.layer.shadowOpacity = 0.6
        rightPostView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(leftPostView)
        stackView.addArrangedSubview(rightPostView)
    }

    private func setupImageViews() {
        leftImageView = UIImageView()
        leftImageView.contentMode = .scaleAspectFill
        leftImageView.clipsToBounds = true
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        leftPostView.addSubview(leftImageView)

        rightImageView = UIImageView()
        rightImageView.contentMode = .scaleAspectFill
        rightImageView.clipsToBounds = true
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        rightPostView.addSubview(rightImageView)

        NSLayoutConstraint.activate([
            leftImageView.topAnchor.constraint(equalTo: leftPostView.topAnchor, constant: 8),
            leftImageView.leadingAnchor.constraint(equalTo: leftPostView.leadingAnchor, constant: 8),
            leftImageView.trailingAnchor.constraint(equalTo: leftPostView.trailingAnchor, constant: -8),
            leftImageView.heightAnchor.constraint(equalToConstant: 100),
            
            rightImageView.topAnchor.constraint(equalTo: rightPostView.topAnchor, constant: 8),
            rightImageView.leadingAnchor.constraint(equalTo: rightPostView.leadingAnchor, constant: 8),
            rightImageView.trailingAnchor.constraint(equalTo: rightPostView.trailingAnchor, constant: -8),
            rightImageView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }

    private func setupLabels() {
        leftLabel = UILabel()
        leftLabel.font = UIFont.boldSystemFont(ofSize: 16)
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        leftPostView.addSubview(leftLabel)

        rightLabel = UILabel()
        rightLabel.font = UIFont.boldSystemFont(ofSize: 16)
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        rightPostView.addSubview(rightLabel)

        NSLayoutConstraint.activate([
            leftLabel.topAnchor.constraint(equalTo: leftImageView.bottomAnchor, constant: 8),
            leftLabel.leadingAnchor.constraint(equalTo: leftPostView.leadingAnchor, constant: 8),
            leftLabel.trailingAnchor.constraint(equalTo: leftPostView.trailingAnchor, constant: -8),
            leftLabel.bottomAnchor.constraint(equalTo: leftPostView.bottomAnchor, constant: -8),
            
            rightLabel.topAnchor.constraint(equalTo: rightImageView.bottomAnchor, constant: 8),
            rightLabel.leadingAnchor.constraint(equalTo: rightPostView.leadingAnchor, constant: 8),
            rightLabel.trailingAnchor.constraint(equalTo: rightPostView.trailingAnchor, constant: -8),
            rightLabel.bottomAnchor.constraint(equalTo: rightPostView.bottomAnchor, constant: -8),
        ])
    }

    private func addGestureRecognizers() {
        let leftTapGesture = UITapGestureRecognizer(target: self, action: #selector(leftPostTappedAction))
        leftPostView.addGestureRecognizer(leftTapGesture)
        leftPostView.isUserInteractionEnabled = true
        
        let rightTapGesture = UITapGestureRecognizer(target: self, action: #selector(rightPostTappedAction))
        rightPostView.addGestureRecognizer(rightTapGesture)
        rightPostView.isUserInteractionEnabled = true
    }

    @objc private func leftPostTappedAction() {
        leftPostTapped?()
    }

    @objc private func rightPostTappedAction() {
        rightPostTapped?()
    }
}
