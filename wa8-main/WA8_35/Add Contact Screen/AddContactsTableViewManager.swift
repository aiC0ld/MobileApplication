//
//  AddContactsTableViewManager.swift
//  WA8_35
//
//  Created by Yu huiying on 11/8/24.
//

import Foundation
import UIKit
import FirebaseFirestore

extension AddContactViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddContactCell", for: indexPath) as! AddContactTableViewCell
        
        let contact = allUsers[indexPath.row]
        cell.labelUser.text = contact.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedContact = allUsers[indexPath.row]
        navigateToChatScreen(with: selectedContact)
    }
}


extension AddContactViewController:ProgressSpinnerDelegate{
    func showActivityIndicator(){
        addChild(childProgressView)
        view.addSubview(childProgressView.view)
        childProgressView.didMove(toParent: self)
    }
    
    func hideActivityIndicator(){
        childProgressView.willMove(toParent: nil)
        childProgressView.view.removeFromSuperview()
        childProgressView.removeFromParent()
    }
}
