//
//  ViewController.swift
//  FinalProject_35
//
//  Created by Zhang Xinjia on 2024/11/21.
//

import UIKit

class ViewController: UIViewController {

    let landingScreen = LandingScreenView()
    
    override func loadView() {
        view = landingScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        landingScreen.signinButton.addTarget(self, action: #selector(signinButtonTapped), for: .touchUpInside)
        landingScreen.registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    @objc func signinButtonTapped() {
        // Navigate to Login Page
        let signInVC = SigninViewController()
        navigationController?.pushViewController(signInVC, animated: true)
    }
    
    @objc func registerButtonTapped() {
        // Navigate to Register Page
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
}
