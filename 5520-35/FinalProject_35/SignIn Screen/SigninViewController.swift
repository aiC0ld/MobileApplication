//
//  SigninViewController.swift
//  FinalProject_35
//
//  Created by Xinyue Han on 12/1/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SigninViewController: UIViewController {
    
    let signInView = SigninView()
    
    override func loadView() {
        view = signInView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        signInView.signinButton.addTarget(self, action: #selector(didTapSignin), for: .touchUpInside)
    }
    
    @objc func didTapSignin() {
        if let email = signInView.emailTextField!.text,
           let password = signInView.passwordTextField!.text{
            //MARK: sign-in logic for Firebase...
            if email.isEmpty {
                self.showAlert(message: "Email cannot be empty")
                return
            }
            if !self.isValidEmail(email: email) {
                self.showAlert(message: "Enter a valid email")
                return
            }
            if password.isEmpty {
                self.showAlert(message: "Password cannot be empty")
                return
            }
            self.signInToFirebase(email: email, password: password)
        }
    }
    
    func signIn(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func signInToFirebase(email: String, password: String){
        //MARK: can you display progress indicator here?
        //MARK: authenticating the user...
        Auth.auth().signIn(withEmail: email, password: password, completion: {(result, error) in
            if error == nil{
                //MARK: user authenticated...
                //MARK: can you hide the progress indicator here?
                let mainScreenVC = MainViewController()
                let tabBarController = TabBarController()
                tabBarController.modalPresentationStyle = .fullScreen
                self.present(tabBarController, animated: true, completion: nil)
                self.navigationController?.pushViewController(mainScreenVC, animated: true)
            }else {
                //MARK: alert that no user found or password wrong...
                self.showAlert(message: "Invalid email or password. Please try again.")
            }
        })
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
}
