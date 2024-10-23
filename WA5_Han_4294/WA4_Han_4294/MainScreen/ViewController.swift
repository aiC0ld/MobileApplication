//
//  ViewController.swift
//  WA4_Han_4294
//
//  Created by Xinyue Han on 10/6/24.
//

import UIKit

class ViewController: UIViewController {
    
    let firstScreen = FirstScreenView()
    var contacts = [Contact]()
    var selectedContactIndex: Int = 0
    
    override func loadView() {
        view = firstScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "My Contacts"
        navigationItem.backButtonTitle = "Back"
        
        //MARK: manipulating TableView separator line...
        firstScreen.tableViewContacts.separatorStyle = .none
        
//        contacts.append(Contact(name: "Alice M",
//                                email: "alicem@gmail.com",
//                                phoneType: "Cell",
//                                phoneNumber: 1234567890,
//                                address: "12 No Street",
//                                cityState: "Boston, MA",
//                                zip: "02125"))
        
        firstScreen.tableViewContacts.delegate = self
        firstScreen.tableViewContacts.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddBarButtonTapped)
        )
    }
    
    func delegateOnEditContact(_ newContact: Contact) {
        contacts[self.selectedContactIndex] = newContact
        firstScreen.tableViewContacts.reloadData()
    }
    
    func delegateOnAddContact(_ contact: Contact) {
        contacts.append(contact)
        firstScreen.tableViewContacts.reloadData()
    }
    
    @objc func onAddBarButtonTapped(){
        let addContactController = AddContactViewController()
        addContactController.delegate = self
        navigationController?.pushViewController(addContactController, animated: true)
    }
    
    func updateTableView(update indexPath: IndexPath, updateContact: Contact) {
        self.contacts[indexPath.row] = updateContact
        firstScreen.tableViewContacts.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contacts", for: indexPath) as! TableViewContactCell
        if let uwImage = contacts[indexPath.row].image{
            cell.imagePhoto.image = uwImage
        }
        cell.labelName.text = contacts[indexPath.row].name
        cell.labelEmail.text = contacts[indexPath.row].email
        if let phoneNumber = contacts[indexPath.row].phoneNumber, let phoneType = contacts[indexPath.row].phoneType {
            cell.labelPhone.text = "\(phoneNumber) (\(phoneType))"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedContact = self.contacts[indexPath.row]
        let displayContactViewController = DisplayContactViewController()
        
        displayContactViewController.profileData = selectedContact
        
        self.navigationController?.pushViewController(displayContactViewController, animated: true)
    }
}

