//
//  AddContactViewController.swift
//  WA8_35
//
//  Created by Yu huiying on 11/8/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class AddContactViewController: UIViewController {
    var addContactView = AddContactView()
    
    var allUsers = [Contact]()
    
    var currentUser: FirebaseAuth.User?
    
    let childProgressView = ProgressSpinnerViewController()
    
    var mainNavigationController: UINavigationController?
    
    override func loadView() {
        self.view = addContactView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addContactView.tableView.delegate = self
        addContactView.tableView.dataSource = self
        addContactView.tableView.register(AddContactTableViewCell.self, forCellReuseIdentifier: "AddContactCell")
        
        fetchAllUsers()
    }
    
    func fetchAllUsers() {
        showActivityIndicator()
        let db = Firestore.firestore()
        db.collection("users").getDocuments { (snapshot, error) in
            self.hideActivityIndicator()
            if let documents = snapshot?.documents {
                self.allUsers.removeAll()
                for document in documents {
                    if let contact = Contact(document: document) {
                        if contact.email != self.currentUser?.email {  // Exclude current user
                            self.allUsers.append(contact)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.addContactView.tableView.reloadData()
                }
            } else {
                print("Error occured: \(String(describing: error))")
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func navigateToChatScreen(with contact: Contact) {
        let chatViewController = ChatViewController()
        chatViewController.contact = contact
        
        dismiss(animated: true) {
            self.mainNavigationController?.pushViewController(chatViewController, animated: true)
        }
    }
    
}
