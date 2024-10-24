//
//  ViewController.swift
//  App10
//
//  Created by Sakib Miazi on 5/25/23.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    let mainScreen = MainScreenView()
    
    //MARK: list to display the contact names in the TableView...
    var contactNames = [String]()
    
    let notificationCenter = NotificationCenter.default
    
    override func loadView() {
        view = mainScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Contacts JSON API"
        
        //MARK: setting the delegate and data source...
        mainScreen.tableViewContacts.dataSource = self
        mainScreen.tableViewContacts.delegate = self
        //MARK: removing the separator line...
        mainScreen.tableViewContacts.separatorStyle = .none
        
        //get all contact names when the main screen loads...
        getAllContacts()
        
        //MARK: add action to Add Contact button...
        mainScreen.buttonAdd.addTarget(self, action: #selector(onButtonAddTapped), for: .touchUpInside)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(refreshContacts(notification:)),
                                       name: Notification.Name("refreshContacts"),
                                       object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(deleteContactNotification(_:)), name: Notification.Name("fromDisplayScreen"), object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(editContactNotification(_:)), name: Notification.Name("fromEditScreen"), object: nil)
    }
    
    @objc func deleteContactNotification(_ notification: Notification) {
        guard let contact = notification.object as? Contact else { return }
        deleteContact(contact: contact)
    }
    
    @objc func editContactNotification(_ notification: Notification) {
        guard let contacts = notification.object as? [String: Contact] else { return }
        let updatedContact = contacts["updated"]!
        let originalContact = contacts["original"]!
        editContact(originalContact: originalContact, contact: updatedContact)
    }
    
    @objc func refreshContacts(notification: Notification){
        getAllContacts()
    }
    
    func editContact(originalContact: Contact, contact: Contact){
        if let url = URL(string: APIConfigs.baseURL+"delete"){
            AF.request(url, method:.get, parameters:
                        [
                            "name": originalContact.name,
                            "email": originalContact.email,
                            "phone": originalContact.phone
                        ], encoding: URLEncoding.queryString)
            .responseString(completionHandler: { response in
                let status = response.response?.statusCode
                
                switch response.result{
                case .success(let data):

                    if let uwStatusCode = status{
                        switch uwStatusCode{
                        case 200...299:
                            self.addANewContact(contact: contact)
                            break
                            
                        case 400...499:
                            print(data)
                            break
                            
                        default:
                            print(data)
                            break
                            
                        }
                    }
                    break
                    
                case .failure(let error):
                    print(error)
                    break
                }
            })
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        
        let email = mainScreen.textFieldAddEmail.text!
        
        
        let isValidEmail = emailPred.evaluate(with: email)
        
        if !isValidEmail {
            showAlert(message: "The email format is invalid.")
        }
        
        return isValidEmail
    }
    
    func isValidPhoneNumber(phoneNumber: String) -> Bool {
        let digitsCharacterSet = CharacterSet.decimalDigits

        if phoneNumber.rangeOfCharacter(from: digitsCharacterSet.inverted) != nil {
            showAlert(message: "Phone number only contains digits.")
            return false
        } else if phoneNumber.count != 10 {
            showAlert(message: "Phone number must be exactly 10 digits")
            return false
        }
        return true
    }
    
    func noEmptyFileds() -> Bool {
        if mainScreen.textFieldAddName.text?.isEmpty == true {
            showAlert(message: "Name cannot be empty")
            return false
        } else if mainScreen.textFieldAddEmail.text?.isEmpty == true {
            showAlert(message: "Email cannot be empty")
            return false
        } else if mainScreen.textFieldAddPhone.text?.isEmpty == true {
            showAlert(message: "Phone number cannot be empty")
            return false
        }
        return true
    }
    
    @objc func onButtonAddTapped() {
        if !noEmptyFileds() {
            return
        }
        
        if !isValidEmail() {
            return
        }
        
        if !isValidPhoneNumber(phoneNumber: mainScreen.textFieldAddPhone.text!) {
            return
        }
        
        if let name = mainScreen.textFieldAddName.text,
           let email = mainScreen.textFieldAddEmail.text,
           let phoneText = mainScreen.textFieldAddPhone.text{
            
            if let phone = Int(phoneText){
                //The String 'phoneText' is successfully converted to an Int...
                let newContact = Contact(name: name, email: email, phone: phone)
                
                //call add a new contact API endpoint...
                addANewContact(contact: newContact)
            }
        }
    }

//    @objc func onButtonAddTapped(){
//        //do the validations...
//        if let name = mainScreen.textFieldAddName.text,
//           let email = mainScreen.textFieldAddEmail.text,
//           let phoneText = mainScreen.textFieldAddPhone.text{
//
//            if let phone = Int(phoneText){
//                //The String 'phoneText' is successfully converted to an Int...
//                let contact = Contact(name: name, email: email, phone: phone)
//
//                //MARK: call add a new contact API endpoint...
//                addANewContact(contact: contact)
//            }else{
//                //alert...
//            }
//        }
//        else{
//            //alert....
//        }
//    }
    
    func clearAddViewFields(){
        mainScreen.textFieldAddName.text = ""
        mainScreen.textFieldAddEmail.text = ""
        mainScreen.textFieldAddPhone.text = ""
    }
    
//    func showDetailsInAlert(data: String){
//        let parts = data.components(separatedBy: ",")
//        print(parts)
//
//        //MARK: trim the whitespaces from the strings, and show alert...
//        let name = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
//        let email = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
//        if let phone = Int(parts[2].trimmingCharacters(in: .whitespacesAndNewlines)){
//            //MARK: show alert...
//            let message = """
//                name: \(name)
//                email: \(email)
//                phone: \(phone)
//                """
//            let alert = UIAlertController(title: "Selected Contact", message: message, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default))
//            self.present(alert, animated: true)
//        }
//
//    }
    
    //MARK: add a new contact call: add endpoint...
    func addANewContact(contact: Contact){
        if let url = URL(string: APIConfigs.baseURL+"add"){
            
            AF.request(url, method:.post, parameters:
                        [
                            "name": contact.name,
                            "email": contact.email,
                            "phone": contact.phone
                        ])
                .responseString(completionHandler: { response in
                    //MARK: retrieving the status code...
                    let status = response.response?.statusCode
                    
                    switch response.result{
                    case .success(let data):
                        //MARK: there was no network error...
                        
                        //MARK: status code is Optional, so unwrapping it...
                        if let uwStatusCode = status{
                            switch uwStatusCode{
                                case 200...299:
                                //MARK: the request was valid 200-level...
                                self.getAllContacts()
                                self.clearAddViewFields()
                                    break
                        
                                case 400...499:
                                //MARK: the request was not valid 400-level...
                                    print(data)
                                    break
                        
                                default:
                                //MARK: probably a 500-level error...
                                    print(data)
                                    break
                        
                            }
                        }
                        break
                        
                    case .failure(let error):
                        //MARK: there was a network error...
                        print(error)
                        break
                    }
                })
        }else{
            //alert that the URL is invalid...
            showAlert(message: "The URL is invalid.")
        }
    }
    
    //MARK: get all contacts call: getall endpoint...
    func getAllContacts(){
        if let url = URL(string: APIConfigs.baseURL + "getall"){
            AF.request(url, method: .get).responseString(completionHandler: { response in
                //MARK: retrieving the status code...
                let status = response.response?.statusCode
                
                switch response.result{
                case .success(let data):
                    //MARK: there was no network error...
                    
                    //MARK: status code is Optional, so unwrapping it...
                    if let uwStatusCode = status{
                        switch uwStatusCode{
                            case 200...299:
                            //MARK: the request was valid 200-level...
                                let names = data.components(separatedBy: "\n")
                                self.contactNames = names
                                self.contactNames.removeLast()
                                self.mainScreen.tableViewContacts.reloadData()
                                print(self.contactNames)
                                break
                    
                            case 400...499:
                            //MARK: the request was not valid 400-level...
                                print(data)
                                break
                    
                            default:
                            //MARK: probably a 500-level error...
                                print(data)
                                break
                    
                        }
                    }
                    break
                    
                case .failure(let error):
                    //MARK: there was a network error...
                    print(error)
                    break
                }
            })
        }
    }
    
    //MARK: get details of a contact...
    func getContactDetails(name: String){
        if let url = URL(string: APIConfigs.baseURL+"details"){
            AF.request(url, method:.get,
                       parameters: ["name":name],
                       encoding: URLEncoding.queryString)
                .responseString(completionHandler: { response in
                
                //MARK: retrieving the status code...
                let status = response.response?.statusCode
                
                switch response.result{
                case .success(let data):
                    //MARK: there was no network error...
                    
                    //MARK: status code is Optional, so unwrapping it...
                    if let uwStatusCode = status{
                        switch uwStatusCode{
                            case 200...299:
                            //MARK: the request was valid 200-level...
                                //MARK: show alert with details...
                                let parts = data.components(separatedBy: ",")
                                let name = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
                                let email = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
                                if let phone = Int(parts[2].trimmingCharacters(in: .whitespacesAndNewlines)) {
                                    let contact = Contact(name: name, email: email, phone: phone)
                                    self.navigateToDisplayScreen(contact: contact)
                                }
//                                self.showDetailsInAlert(data: data)
                                break
                    
                            case 400...499:
                            //MARK: the request was not valid 400-level...
                                print(data)
                                break
                    
                            default:
                            //MARK: probably a 500-level error...
                                print(data)
                                break
                    
                        }
                    }
                    break
                    
                case .failure(let error):
                    //MARK: there was a network error...
                    print(error)
                    break
                }
            })
        }
    }
    
    func navigateToDisplayScreen(contact: Contact) {
        let displayScreenViewController = DisplayScreenViewController(contact: contact)
        navigationController?.pushViewController(displayScreenViewController, animated: true)
    }
    
//    func handleDeleteContact(contact: Contact) {
//        let alert = UIAlertController(title: "Delete Contact", message: "Are you sure you want to delete \(contact.name)?", preferredStyle: .alert)
//            
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
//                self.deleteContact(name: name)
//            }))
//            
//            self.present(alert, animated: true)
//        }

    func deleteContact(contact: Contact) {
        if let url = URL(string: APIConfigs.baseURL + "delete") {
            AF.request(url, method: .get, parameters: ["name": contact.name,
                                                       "email": contact.email,
                                                       "phone": contact.phone], encoding: URLEncoding.queryString)
                .responseString { response in
                    let status = response.response?.statusCode
                    
                    switch response.result {
                    case .success(let data):
                        if let uwStatusCode = status {
                            switch uwStatusCode {
                            case 200...299:
                                self.getAllContacts()
                            case 400...499:
                                print("Error: \(data)")
                            default:
                                print("Error: \(data)")
                            }
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
        } else {
            showAlert(message: "Invalid API")
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "names", for: indexPath) as! ContactsTableViewCell
        cell.labelName.text = contactNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getContactDetails(name: self.contactNames[indexPath.row])
    }
}

