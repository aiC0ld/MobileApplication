//
//  ViewController.swift
//  WA07_Xu_9492
//
//  Created by Aiden Hsu on 11/2/23.
//

import UIKit

class ViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    let notificationCenter = NotificationCenter.default
    let loginPage = LoginPageView()
    
    override func loadView() {
        view = loginPage

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if (checkLogin()) {
            // MARK: we have logged in already， Push notesPage out
            pushOutNotesPage(animated: false)
        }
        
        //MARK: add action to ButtonDelete and loginButton
        loginPage.registerButton.addTarget(self, action: #selector(onButtonDeleteTapped), for: .touchUpInside)
        loginPage.loginButton.addTarget(self, action: #selector(onLoginButtonTapped), for: .touchUpInside)
        
        //MARK: recognizing the taps on the app screen, not the keyboard...
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    // MARK: Give functionbility to registerButton
    @objc func onButtonDeleteTapped() {
        let registerPage = RegisterPageViewController()
        navigationController?.pushViewController(registerPage, animated: true)
    }
    
    // MARK: Give functionbility to LoginButton
    @objc func onLoginButtonTapped() {
        login(email: loginPage.emailFeild.text!, password: loginPage.pwFeild.text!)
        
        notificationCenter.addObserver(
            self,
            selector: #selector(setToken(notification:)),
            name:.tokenRecieved,
            object: nil)
    }
    
    func login(email:String, password:String) {
        if let url = URL(string: APIConfigs.AuthURL+"login"){
            AF.request(url, method: .post, parameters: [
                                            "email": email,
                                            "password": password
                                        ]
            ).responseData(completionHandler: { response in
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
                                let decoder = JSONDecoder()
                                do{
                                    let receivedData =
                                        try decoder
                                        .decode(AuthToken.self, from: data)
                                    if (receivedData.auth) {
                                        // MARK: authed
                                        
                                        self.notificationCenter.post(
                                            name: .tokenRecieved,
                                            object: receivedData.token)
                                        
                                        print("Auth Token Get \(receivedData.token)")
                                    } else {
                                        // fail to auth
                                        let alert = UIAlertController(title: "Error!", message: "Check password or email", preferredStyle: .alert)
                                        
                                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                                        
                                        self.present(alert, animated: true)
                                    }
                                }catch{
                                    print("JSON couldn't be decoded.")
                                    let alert = UIAlertController(title: "Error!", message: "Check password or email", preferredStyle: .alert)
                                    
                                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                                    
                                    self.present(alert, animated: true)
                                }
                                break
                    
                            case 400...499:
                            //MARK: the request was not valid 400-level...
                            let alert = UIAlertController(title: "Error!", message: "Check password or email", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            
                            self.present(alert, animated: true)
                                break
                    
                            default:
                            //MARK: probably a 500-level error...
                            let alert = UIAlertController(title: "Error!", message: "Check password or email", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            
                            self.present(alert, animated: true)
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
    
    @objc func setToken(notification: Notification){
        defaults.set(notification.object as! String, forKey: "AuthToken")
        print("Auth Token now set as \(notification.object as! String)")
        
        pushOutNotesPage(animated: true)
    }
    
    func getToken() -> String? {
        let AuthTokenSaved = defaults.object(forKey: "AuthToken") as! String?
        
        if let token = AuthTokenSaved{
            //MARK: tasks if there is a key saved
            print("The Saved Auth Token: \(token)")
            return token
        }
        return nil
    }
    
    func pushOutNotesPage(animated: Bool) {
        let notesPage = NotesPageViewController()
        navigationController?.pushViewController(notesPage, animated: animated)
    }
    
    
    
    // MARK: Check if already signed in
    func checkLogin() -> Bool {
        return getToken() != nil
    }
    
    //MARK: Hide Keyboard...
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen...
        view.endEditing(true)
    }
}

