//
//  ContactsTableViewManager.swift
//  WA8_35
//
//  Created by Yu huiying on 11/8/24.
//
import Foundation
import UIKit
import FirebaseFirestore

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewChatsId, for: indexPath) as! ContactsTableViewCell
        cell.labelName.text = chatsList[indexPath.row].senderName
        cell.labelEmail.text = ""
        cell.labelMessage.text = chatsList[indexPath.row].lastMessage
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let timestampString = dateFormatter.string(from: chatsList[indexPath.row].timestamp)
        cell.labelTime.text = "\(timestampString)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedChat = chatsList[indexPath.row]
        let chatViewController = ChatViewController()
        chatViewController.contact = selectedChat.contact
        chatViewController.currentUser = Contact(
            id: currentUser?.uid,
            name: currentUser?.displayName ?? "You",
            email: currentUser?.email ?? ""
        )
        navigationController?.pushViewController(chatViewController, animated: true)
    }
}
