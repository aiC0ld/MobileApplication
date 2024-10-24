//
//  DisplayScreenViewController.swift
//  App10
//
//  Created by Xinyue Han on 10/23/24.
//

import UIKit

class DisplayScreenViewController: UIViewController {
    
    let displayScreen = DisplayScreenView()
    var contact: Contact?
    
    let notificationCenter = NotificationCenter.default
    
    init(contact: Contact) {
        self.contact = contact
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = displayScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Contact"

        // Do any additional setup after loading the view.
        
        if let unwrappedContact = contact {
            displayScreen.nameLabel.text = "Name: \(unwrappedContact.name)"
            displayScreen.emailLabel.text = "Email: \(unwrappedContact.email)"
            displayScreen.phoneLabel.text = "Phone: \(unwrappedContact.phone)"
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .edit, target: self,
            action: #selector(onEditBarButtonTapped)
        )
        
        displayScreen.deleteButton.addTarget(self, action: #selector(onDeleteButtonTapped), for: .touchUpInside)
        
        notificationCenter.addObserver(self, selector: #selector(updateContact(_:)), name: Notification.Name("fromEditScreen"), object: nil)
    }
    
    @objc func updateContact(_ notification: Notification) {
        guard let contacts = notification.object as? [String: Contact] else { return }
        let updatedContact = contacts["updated"]!
        self.contact = updatedContact
        contactDetails()
    }
    
    func contactDetails() {
        if let contact = contact {
            displayScreen.nameLabel.text = contact.name
            displayScreen.emailLabel.text = contact.email
            displayScreen.phoneLabel.text = String(contact.phone)
        }
    }
    
    @objc func onEditBarButtonTapped(){
        let editScreen = EditScreenViewController()
        editScreen.contact = contact
        navigationController?.pushViewController(editScreen, animated: true)
    }
    
    @objc func onDeleteButtonTapped(){
        let alert = UIAlertController(title: "Delete Contact",
                                      message: "Are you sure you want to delete the contact?",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
            if let unwarppedContact =  self.contact {
                self.notificationCenter.post(
                                name: Notification.Name("fromDisplayScreen"),
                                object: unwarppedContact)
            }
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
