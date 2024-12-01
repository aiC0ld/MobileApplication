//
//  ChatViewController.swift
//  WA8_35
//
//  Created by Zhang Xinjia on 2024/11/13.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var contact: Contact? // The friend the current user is chatting with
    var currentUser: Contact?
    var tableView: UITableView!
    var messages: [Message] = []
    var inputTextField: UITextField!
    var sendButton: UIButton!
    var db: Firestore!
    var inputContainerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the title to the contact's name
        self.title = contact?.name ?? "Chat"

        // Initialize Firestore
        db = Firestore.firestore()

        // Fetch the current user's details
        fetchCurrentUser()

        // Set up the UI components
        setupInputComponents()
        setupTableView()

        // Load messages from Firestore
        loadMessages()
    }

    func fetchCurrentUser() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }

        let userDocRef = db.collection("users").document(currentUserID)
        userDocRef.getDocument { (documentSnapshot, error) in
            if let e = error {
                print("Error fetching current user: \(e.localizedDescription)")
            } else if let document = documentSnapshot, document.exists {
                self.currentUser = Contact(document: document)
            }
        }
    }

    func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self

        // Register custom cells
        tableView.register(MyMessageCell.self, forCellReuseIdentifier: "MyMessageCell")
        tableView.register(FriendMessageCell.self, forCellReuseIdentifier: "FriendMessageCell")

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.separatorStyle = .none

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        // Set up constraints for tableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

    func setupInputComponents() {
        inputContainerView = UIView()
        inputContainerView.backgroundColor = .white
        inputContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputContainerView)

        inputTextField = UITextField()
        inputTextField.placeholder = "Type a message"
        inputTextField.borderStyle = .roundedRect
        inputTextField.translatesAutoresizingMaskIntoConstraints = false

        sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false

        inputContainerView.addSubview(inputTextField)
        inputContainerView.addSubview(sendButton)

        // Constraints for inputContainerView
        NSLayoutConstraint.activate([
            inputContainerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            inputContainerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            inputContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            inputContainerView.heightAnchor.constraint(equalToConstant: 60)
        ])

        // Constraints for inputTextField and sendButton
        NSLayoutConstraint.activate([
            inputTextField.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor),
            inputTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 8),
            inputTextField.heightAnchor.constraint(equalToConstant: 40),

            sendButton.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor),
            sendButton.leftAnchor.constraint(equalTo: inputTextField.rightAnchor, constant: 8),
            sendButton.rightAnchor.constraint(equalTo: inputContainerView.rightAnchor, constant: -8),

            inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -8)
        ])
    }

    func loadMessages() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else { return }
        guard let contactEmail = contact?.email else { return }

        let chatID = generateChatID(email1: currentUserEmail, email2: contactEmail)
        
        db.collection("messages")
            .whereField("chatID", isEqualTo: chatID)
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { (querySnapshot, error) in
                if let e = error {
                    print("Error retrieving messages: \(e.localizedDescription)")
                } else {
                    self.messages = []
                    for document in querySnapshot!.documents {
                        if let message = Message(document: document) {
                            self.messages.append(message)
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.scrollToBottom()
                    }
                }
        }
    }

    func scrollToBottom() {
        if messages.count > 0 {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    @objc func sendButtonTapped() {
        print("sendButtonTapped called")
        guard let text = inputTextField.text, !text.isEmpty else {
            print("Text is empty or nil")
            return
        }
        print("Text: \(text)")

        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Current user ID is nil")
            return
        }
        print("Current User ID: \(currentUserID)")

        guard let contactID = contact?.id else {
            print("Contact ID is nil")
            return
        }
        print("Contact ID: \(contactID)")
        
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            print("Current user email is nil")
            return
        }
        print("Current User Email: \(currentUserEmail)")

        guard let contactEmail = contact?.email else {
            print("Contact email is nil")
            return
        }
        print("Contact Email: \(contactEmail)")

        let chatID = generateChatID(email1: currentUserEmail, email2: contactEmail)
        print("Chat ID: \(chatID)")

        let messageData: [String: Any] = [
            "senderID": currentUserID,
            "receiverID": contactID,
            "text": text,
            "timestamp": FieldValue.serverTimestamp(),
            "chatID": chatID
        ]

        print("Message Data Prepared")

        db.collection("messages").addDocument(data: messageData) { error in
            if let e = error {
                print("Error sending message: \(e.localizedDescription)")
            } else {
                print("Message sent successfully")
                DispatchQueue.main.async {
                    self.inputTextField.text = ""
                    
                    self.loadMessages()
                    self.scrollToBottom()
                }
            }
        }
        print("sendButtonTapped function completed")
    }

    // Generate a consistent chatID for the chat between two users
    func generateChatID(email1: String, email2: String) -> String {
        return email1 < email2 ? "\(email1)_\(email2)" : "\(email2)_\(email1)"
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let message = messages[indexPath.row]
        let senderID = message.senderID
        let currentUserID = Auth.auth().currentUser?.uid

        if senderID == currentUserID {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell", for: indexPath) as! MyMessageCell
            cell.messageLabel.text = message.text

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, h:mm a"
            let timestampString = dateFormatter.string(from: message.timestamp)
            cell.timestampLabel.text = "You at \(timestampString)"

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendMessageCell", for: indexPath) as! FriendMessageCell
            cell.messageLabel.text = message.text
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, h:mm a"
            let timestampString = dateFormatter.string(from: message.timestamp)
            let senderName = contact?.name ?? "Friend"
            cell.timestampLabel.text = "\(senderName) at \(timestampString)"

            return cell
        }
    }
}

