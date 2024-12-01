//
//  ViewController.swift
//  WA8_35
//
//  Created by Zhang Xinjia on 2024/11/7.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {
    
    let mainScreen = MainScreenView()
    
    var contactsList = [Contact]()
    
    var chatsList = [Chat]()
    
    var handleAuth: AuthStateDidChangeListenerHandle?
    
    var currentUser:FirebaseAuth.User?
    
    let database = Firestore.firestore()
    
    override func loadView() {
        view = mainScreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //MARK: handling if the Authentication state is changed (sign in, sign out, register)...
        handleAuth = Auth.auth().addStateDidChangeListener{ auth, user in
            if user == nil{
                //MARK: not signed in...
                self.currentUser = nil
                self.mainScreen.labelText.text = "Please sign in to send the chats!"
                self.mainScreen.floatingButtonAddContact.isEnabled = false
                self.mainScreen.floatingButtonAddContact.isHidden = true
                
                //MARK: Reset tableView...
                self.contactsList.removeAll()
                self.mainScreen.tableViewContacts.reloadData()
                
                //MARK: Sign in bar button...
                self.setupRightBarButton(isLoggedin: false)
                
            }else{
                //MARK: the user is signed in...
                self.currentUser = user
                self.mainScreen.labelText.text = "Welcome \(user?.displayName ?? "Anonymous")!"
                self.mainScreen.floatingButtonAddContact.isEnabled = true
                self.mainScreen.floatingButtonAddContact.isHidden = false
                
                //MARK: Logout bar button...
                self.setupRightBarButton(isLoggedin: true)
                
                //MARK: Observe Firestore database to display the contacts list...
                self.database.collection("users")
                    .document((self.currentUser?.email)!)
                    .collection("contacts")
                    .addSnapshotListener(includeMetadataChanges: false, listener: {querySnapshot, error in
                        if let documents = querySnapshot?.documents{
                            self.contactsList.removeAll()
                            for document in documents{
                                do{
                                    let contact  = try document.data(as: Contact.self)
                                    self.contactsList.append(contact)
                                }catch{
                                    print(error)
                                }
                            }
                            self.contactsList.sort(by: {$0.name < $1.name})
                            self.mainScreen.tableViewContacts.reloadData()
                        }
                    })
                self.fetchChats()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Chats"
        
        //MARK: patching table view delegate and data source...
        mainScreen.tableViewContacts.delegate = self
        mainScreen.tableViewContacts.dataSource = self
        
        //MARK: removing the separator line...
        mainScreen.tableViewContacts.separatorStyle = .none
        
        //MARK: Make the titles look large...
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //MARK: Put the floating button above all the views...
        view.bringSubviewToFront(mainScreen.floatingButtonAddContact)
        
        //MARK: tapping the floating add contact button...
        mainScreen.floatingButtonAddContact.addTarget(self, action: #selector(addContactButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handleAuth!)
    }
    
    func signIn(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password)
    }
    
    @objc func addContactButtonTapped() {
        let addContactController = AddContactViewController()
        addContactController.currentUser = self.currentUser
        addContactController.mainNavigationController = self.navigationController
        
        // buttom sheet
        addContactController.modalPresentationStyle = .pageSheet
        if let sheet = addContactController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 16
        }
        
        present(addContactController, animated: true, completion: nil)
    }
    
    private func fetchChats() {
        guard let currentUserEmail = currentUser?.email else {
            print("Error: Current user email is nil")
            return
        }

        let dispatchGroup = DispatchGroup()
        var contactsMap: [String: (contact: Contact?, latestMessage: Message)] = [:]
        
        database.collection("messages").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error fetching chats: \(error.localizedDescription)")
                return
            }

            for document in querySnapshot?.documents ?? [] {
                if let message = Message(document: document),
                   message.chatID.contains(currentUserEmail) {

                    let chatIDComponents = message.chatID.split(separator: "_").map(String.init)
                    let otherEmail = chatIDComponents.first { $0 != currentUserEmail } ?? ""

                    if let existingEntry = contactsMap[otherEmail] {
                        if message.timestamp > existingEntry.latestMessage.timestamp {
                            contactsMap[otherEmail]?.latestMessage = message
                        }
                    } else {
                        contactsMap[otherEmail] = (contact: nil, latestMessage: message)
                        dispatchGroup.enter()
                        self.database.collection("users")
                            .whereField("email", isEqualTo: otherEmail)
                            .getDocuments { (snapshot, error) in
                                if let userDoc = snapshot?.documents.first,
                                   let contact = Contact(document: userDoc) {
                                    contactsMap[otherEmail]?.contact = contact
//                                    contactsMap[otherEmail] = (contact, message)
                                }
                                dispatchGroup.leave()
                            }
                    }
                }
            }
            dispatchGroup.notify(queue: .main) {
                self.updateTableViewWithChats(contactsMap: contactsMap)
            }
        }
    }

    private func updateTableViewWithChats(contactsMap: [String: (contact: Contact?, latestMessage: Message)]) {
        DispatchQueue.global(qos: .userInitiated).async {
            var tempChatsList = [Chat]()
            var tempContactsList = [Contact]()
            
            for entry in contactsMap.values {
                if let contact = entry.contact {
                    tempContactsList.append(contact)
                    tempChatsList.append(Chat(contact: contact,
                                              senderName: contact.name,
                                              lastMessage: entry.latestMessage.text,
                                              timestamp: entry.latestMessage.timestamp))
                }
            }
            
            tempContactsList.sort { $0.name < $1.name }
            tempChatsList.sort { $0.timestamp > $1.timestamp } // Sort by latest message
            
            DispatchQueue.main.async {
                self.contactsList = tempContactsList
                self.chatsList = tempChatsList
                self.mainScreen.tableViewContacts.reloadData()
            }
        }
    }
}
