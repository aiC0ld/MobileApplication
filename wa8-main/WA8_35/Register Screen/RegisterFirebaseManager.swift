//
//  RegisterFirebaseManager.swift
//  WA8_35
//
//  Created by Yu huiying on 11/8/24.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

extension RegisterViewController{
    func registerNewAccount(){
        //MARK: display the progress indicator...
        showActivityIndicator()
        //MARK: create a Firebase user with email and password...
        if let name = registerView.textFieldName.text,
           let email = registerView.textFieldEmail.text,
           let password = registerView.textFieldPassword.text,
           let repeatPassword = registerView.textFieldRepeatPassword.text{
            //Validations....
            if name.isEmpty {
                showAlert(message: "Name cannot be empty")
                hideActivityIndicator()
                return
            }
            
            if email.isEmpty {
                showAlert(message: "Email cannot be empty")
                hideActivityIndicator()
                return
            }
            
            if !isValidEmail(email: email) {
                showAlert(message: "Enter a valid email")
                hideActivityIndicator()
                return
            }
            
            if password.isEmpty {
                showAlert(message: "Password cannot be empty")
                hideActivityIndicator()
                return
            }
            
            if password.count < 6 {
                showAlert(message: "Password must be at least 6 characters")
                hideActivityIndicator()
                return
            }
            
            if password != repeatPassword {
                showAlert(message: "Password does not match")
                hideActivityIndicator()
                return
            }
            
            Auth.auth().createUser(withEmail: email, password: password, completion: {result, error in
                if error == nil{
                    //MARK: the user creation is successful...
                    self.setNameOfTheUserInFirebaseAuth(name: name)
                }else{
                    //MARK: there is a error creating the user...
                    if let error = error as NSError?, error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                        self.showAlert(message: "This email is already in use")
                        self.hideActivityIndicator()
                    } else {
                        print("Error occured: \(String(describing: error))")
                    }
                }
                
                if let user = result?.user {
                    self.saveUserToFirestore(user: user, name: name)
                    
                }
            })
        }
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: We set the name of the user after we create the account...
    func setNameOfTheUserInFirebaseAuth(name: String){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges(completion: {(error) in
            if error == nil{
                //MARK: the profile update is successful...
                
                //MARK: hide the progress indicator...
                self.hideActivityIndicator()
                
                //MARK: pop the current controller...
                self.navigationController?.popViewController(animated: true)
            }else{
                //MARK: there was an error updating the profile...
                print("Error occured: \(String(describing: error))")
            }
        })
    }
    
    
    func saveUserToFirestore(user: FirebaseAuth.User, name: String) {
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).setData([
            "name": name,
            "email": user.email ?? ""
        ]) { error in
            self.hideActivityIndicator()
            if let error = error {
                print("Error occured: \(String(describing: error))")
            } else {
                
            }
        }
    }
    
  
}
