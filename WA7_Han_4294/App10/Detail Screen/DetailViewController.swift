//
//  DetailViewController.swift
//  App10
//
//  Created by Xinyue Han on 11/3/24.
//

import UIKit
import Alamofire

class DetailViewController: UIViewController {
    
    let showProfile = DetailScreenView()
    
    let notificationCenter = NotificationCenter.default
    
    var token = ""
    
    override func loadView() {
        view = showProfile
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Profile"
        
        token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        showProfile.buttonLogOut.addTarget(self, action: #selector(onLogoutButtonTapped), for: .touchUpInside)
        
        getProfile(token: token)
    }
    
    @objc func onLogoutButtonTapped() {
        UserDefaults.standard.removeObject(forKey: "authToken")
        self.dismiss(animated: true, completion: nil)
        self.token = ""
        let loginViewController = LoginViewController()
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    func logout() {
        if let url = URL(string: APIConfigs.authenticationBaseURL + "logout") {
            
            AF.request(url, method: .get, headers: [
                "x-access-token": token
            ])
            .responseString { response in
                let status = response.response?.statusCode
                switch response.result {
                case .success(let data):
                    if let uwStatusCode = status {
                        switch uwStatusCode {
                        case 200...299:
                            print("Logout successful: \(data)")
                            UserDefaults.standard.removeObject(forKey: "authToken")
                            NotificationCenter.default.post(name: Notification.Name("fromLogoutScreen"), object: nil)
                            self.navigationController?.popViewController(animated: true)
                            
                        case 400...499:
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
    
    
    func getProfile(token: String) {
        if let url = URL(string: APIConfigs.authenticationBaseURL + "me") {
            
            AF.request(url, method: .get, headers: [
                "x-access-token": token
            ])
            .responseString { response in
                let status = response.response?.statusCode
                
                switch response.result {
                case .success(let data):
                    if let uwStatusCode = status {
                        switch uwStatusCode {
                        case 200...299:
                            if let jsonData = data.data(using: .utf8) {
                                do {
                                    let decoder = JSONDecoder()
                                    let user = try decoder.decode(User.self, from: jsonData)
                                    
                                    self.showProfile.labelName.text = "Name: \(user.name)"
                                    self.showProfile.labelEmail.text = "Email: \(user.email)"
                                    
                                } catch {
                                    print("Error profile data: \(error)")
                                }
                            }
                        case 400...499:
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
