//
//  RegisterViewController.swift
//  App10
//
//  Created by Xinyue Han on 11/3/24.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {
    
    let registerScreen = RegisterScreenView()
    
    let notificationCenter = NotificationCenter.default
    
    override func loadView() {
        view = registerScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Register Account"
        
        registerScreen.buttonRegister.addTarget(self, action: #selector(onRegisterButtonTapped), for: .touchUpInside)
        registerScreen.buttonLogin.addTarget(self, action: #selector(onLoginButtonTapped), for: .touchUpInside)
        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func hideKeyboardOnTap() {
        view.endEditing(true)
    }
    
    @objc func onRegisterButtonTapped() {
        let name = registerScreen.textFieldName.text ?? ""
        let email = registerScreen.textFieldEmail.text ?? ""
        let password = registerScreen.textFieldPassword.text ?? ""
        
        if name.isEmpty {
            showAlert(message: "Name cannot be empty!")
            return
        }
        
        if email.isEmpty {
            showAlert(message: "Email cannot be empty!")
            return
        }
        
        if !isValidEmail(email: email) {
            showAlert(message: "Please enter a valid email!")
            return
        }
        
        if password.isEmpty {
            showAlert(message: "Password cannot be empty!")
            return
        }
        
        register(name: name, email: email, password: password)
    }
    
    @objc func onLoginButtonTapped() {
        let loginViewController = LoginViewController()
        loginViewController.modalPresentationStyle = .fullScreen
        self.present(loginViewController, animated: true, completion: {
        })
    }
    
    func register(name: String, email: String, password: String) {
        if let url = URL(string: APIConfigs.authenticationBaseURL + "register") {
            
            AF.request(url, method: .post, parameters:
                        [
                            "name": name,
                            "email": email,
                            "password": password
                        ], encoding: URLEncoding.default)
                .responseString { response in
                    let status = response.response?.statusCode
                    
                    switch response.result {
                    case .success(let data):
                        // Unwrap the status code
                        if let uwStatusCode = status {
                            switch uwStatusCode {
                            case 200...299:
                                if let jsonData = data.data(using: .utf8) {
                                    do {
                                        if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                                           let token = json["token"] as? String {
                                            
                                            UserDefaults.standard.set(token, forKey: "authToken")
                                            NotificationCenter.default.post(name: Notification.Name("fromRegisterScreen"), object: nil)
                                            self.dismiss(animated: true, completion: nil)
                                            
                                            let viewController = ViewController()
                                            viewController.token = token
                                            self.navigationController?.pushViewController(viewController, animated: true)
                                        } 
                                    } catch {
                                        print("Error token: \(error)")
                                    }
                                }
                                
                            case 400...499:
                                self.showAlert(message: "User already existed")
                                print(data)
                                break
                                
                            default:
                                print(data)
                                break
                            }
                        }
                        
                    case .failure(let error):
                        print(error)
                        break
                    }
                }
        } else {
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
}
