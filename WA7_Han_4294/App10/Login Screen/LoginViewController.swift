//
//  LoginViewController.swift
//  App10
//
//  Created by Xinyue Han on 11/3/24.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    let loginScreen = LoginScreenView()
    
    let defaults = UserDefaults.standard
    let notificationCenter = NotificationCenter.default
    
    override func loadView() {
        view = loginScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loginScreen.buttonLogin.addTarget(self, action: #selector(onLoginButtonTapped), for: .touchUpInside)
        loginScreen.buttonRegister.addTarget(self, action: #selector(onRegisterButtonTapped), for: .touchUpInside)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen...
        view.endEditing(true)
    }
    
    @objc func onLoginButtonTapped(){
        
        let email = loginScreen.textFieldEmail.text ?? ""
        let password = loginScreen.textFieldPassword.text ?? ""
        
        if email.isEmpty {
            showAlert(message: "Email cannot be empty")
            return
        }
        
        if password.isEmpty {
            showAlert(message: "Password cannot be empty")
            return
        }
        
        if !isValidEmail(email: email) {
            showAlert(message: "Enter a valid email")
            return
        }
        
        login(email: email, password: password)
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func login(email: String, password: String) {
        if let url = URL(string: APIConfigs.authenticationBaseURL + "login") {
            
            AF.request(url, method: .post, parameters: ["email": email, "password": password], encoding: URLEncoding.default)
                .responseString { response in
                    // Retrieve the status code
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
                                            NotificationCenter.default.post(name: Notification.Name("fromLoginScreen"), object: nil)
                                            self.dismiss(animated: true, completion: nil)
                                           
                                            let viewC = ViewController()
                                            viewC.token = token
                                            self.navigationController?.pushViewController(viewC, animated: true)
                                        } else {
                                            print("Token missing in response.")
                                        }
                                    } catch {
                                        print("Error token: \(error)")
                                    }
                                }
                                
                            case 401:
                                self.showAlert(message: "Incorrect password!")
                                print(data)
                                break
                                
                            case 404:
                                self.showAlert(message: "User email not found!")
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
                    
    @objc
    func onRegisterButtonTapped() {
        let registerViewController = RegisterViewController()
        registerViewController.modalPresentationStyle = .fullScreen
        self.present(registerViewController, animated: true, completion: {
        })
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
