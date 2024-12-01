//
//  FriendMessageCell.swift
//  WA8_35
//
//  Created by Zhang Xinjia on 2024/11/14.
//

import UIKit

class FriendMessageCell: UITableViewCell {
    let messageLabel = UILabel()
    let timestampLabel = UILabel()
    let bubbleBackgroundView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        bubbleBackgroundView.backgroundColor = UIColor(white: 0.90, alpha: 1)
        bubbleBackgroundView.layer.cornerRadius = 16
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bubbleBackgroundView)

        messageLabel.numberOfLines = 0
        messageLabel.textColor = .black
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroundView.addSubview(messageLabel)

        timestampLabel.font = UIFont.systemFont(ofSize: 10)
        timestampLabel.textColor = .darkGray
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroundView.addSubview(timestampLabel)

        // Constraints
        NSLayoutConstraint.activate([
            bubbleBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            bubbleBackgroundView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            bubbleBackgroundView.rightAnchor.constraint(lessThanOrEqualTo: contentView.centerXAnchor),

            messageLabel.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor, constant: 8),
            messageLabel.leftAnchor.constraint(equalTo: bubbleBackgroundView.leftAnchor, constant: 12),
            messageLabel.rightAnchor.constraint(equalTo: bubbleBackgroundView.rightAnchor, constant: -12),

            timestampLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 4),
            timestampLabel.leftAnchor.constraint(equalTo: bubbleBackgroundView.leftAnchor, constant: 12),
            timestampLabel.rightAnchor.constraint(equalTo: bubbleBackgroundView.rightAnchor, constant: -12),
            timestampLabel.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: -8),
        ])
        backgroundColor = .clear
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}