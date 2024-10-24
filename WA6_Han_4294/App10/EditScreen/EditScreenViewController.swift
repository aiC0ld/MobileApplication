//
//  EditScreenViewController.swift
//  App10
//
//  Created by Xinyue Han on 10/23/24.
//

import UIKit
import Alamofire

class EditScreenViewController: UIViewController {
    
    let editScreen = EditScreenView()
    
    let notificationCenter = NotificationCenter.default
    
    var contact: Contact?
    
    override func loadView() {
        view = editScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Edit Contact"
        
        editScreen.buttonSave.addTarget(self, action: #selector(onSaveButtonTapped), for: .touchUpInside)
        
        if let unwrappedContact = contact {
            editScreen.nameTextField.text = unwrappedContact.name
            editScreen.emailTextField.text = unwrappedContact.email
            editScreen.phoneNumberTextField.text = String(unwrappedContact.phone)
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen...
        view.endEditing(true)
    }
    
    @objc func onSaveButtonTapped() {
        if !noEmptyFileds() {
            return
        }

        if !isValidEmail() {
            return
        }

        if !isValidPhoneNumber(phoneNumber: editScreen.phoneNumberTextField.text!) {
            return
        }
        let name = editScreen.nameTextField.text ?? ""
        let email = editScreen.emailTextField.text ?? ""
        let phone = editScreen.phoneNumberTextField.text ?? ""
        
        let updatedContact = Contact(name: name, email: email, phone: Int(phone) ?? 0)

        notificationCenter.post(name: Notification.Name("fromEditScreen"), object: ["updated": updatedContact, "original": contact!])
        navigationController?.popViewController(animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        
        let email = editScreen.emailTextField.text!
        
        
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
        if editScreen.nameTextField.text?.isEmpty == true {
            showAlert(message: "Name cannot be empty")
            return false
        } else if editScreen.emailTextField.text?.isEmpty == true {
            showAlert(message: "Email cannot be empty")
            return false
        } else if editScreen.phoneNumberTextField.text?.isEmpty == true {
            showAlert(message: "Phone number cannot be empty")
            return false
        }
        return true
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
