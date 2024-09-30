//
//  ViewController.swift
//  WA3_Han_4294
//
//  Created by Xinyue Han on 9/27/24.
//

import UIKit

class ViewController: UIViewController {

    public struct Profile {
        var name: String?
        var email: String?
        var phoneType: String?
        var phoneNumber: String?
        var address: String?
        var cityState: String?
        var zip: String?
        
        init(name: String? = nil, email: String? = nil, phoneType: String? = nil, phoneNumber: String? = nil, address: String? = nil, cityState: String? = nil, zip: String? = nil) {
            self.name = name
            self.email = email
            self.phoneType = phoneType
            self.phoneNumber = phoneNumber
            self.address = address
            self.cityState = cityState
            self.zip = zip
        }
    }
    
    let createProfileScreen = CreateProfileScreenView()
    
    let phoneType: [String] = ["Cell", "Work", "Home"]
    var selectedPhoneType = "Cell"
    
    // Add the view to this controller while the view is loading...
    override func loadView() {
        view = createProfileScreen
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        title = "Create Profile"
                navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26)]
                navigationController?.navigationBar.setTitleVerticalPositionAdjustment(16, for: .default)
        
        createProfileScreen.phonePicker.delegate = self
        createProfileScreen.phonePicker.dataSource = self
        
        createProfileScreen.showProfileButton.addTarget(self, action: #selector(onShowProfileButtonTapped), for: .touchUpInside)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
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
    
    func isValidCityState(cityState: String) -> Bool {
        let components = cityState.split(separator: ",").map { component in component.trimmingCharacters(in: .whitespaces)
        }
        if components.count != 2 {
            showAlert(message: "City, State should have two words seperated by a comma.")
            return false
        }
        return true
    }
    
    func isValidZipCode(zip: String) -> Bool {
        let digitsCharacterSet = CharacterSet.decimalDigits
        if zip.rangeOfCharacter(from: digitsCharacterSet.inverted) != nil {
            showAlert(message: "Zip code only contains digits.")
            return false
        } else if zip.count != 5 {
            showAlert(message: "Zip code must be exactly 5-digit.")
            return false
        } else if let intZip = Int(zip), intZip < 1 || intZip > 99950 {
            showAlert(message: "Zip code must be between 00001 and 99950")
            return false
        }
        return true
    }
    
    func noEmptyFileds() -> Bool {
        if createProfileScreen.nameTextField.text?.isEmpty == true {
            showAlert(message: "Name cannot be empty")
            return false
        } else if createProfileScreen.emailTextField.text?.isEmpty == true {
            showAlert(message: "Email cannot be empty")
            return false
        } else if createProfileScreen.phoneNumberTextField.text?.isEmpty == true {
            showAlert(message: "Phone number cannot be empty")
            return false
        } else if createProfileScreen.addressTextField.text?.isEmpty == true {
            showAlert(message: "Address cannot be empty")
            return false
        } else if createProfileScreen.cityStateTextField.text?.isEmpty == true {
            showAlert(message: "City cannot be empty")
            return false
        } else if createProfileScreen.zipTextField.text?.isEmpty == true {
            showAlert(message: "Zip cannot be empty")
            return false
        }
        return true
    }
    
    @objc func onShowProfileButtonTapped() {
        
        if !noEmptyFileds() {
            return
        }
        
        let name = createProfileScreen.nameTextField.text ?? ""
        let email = createProfileScreen.emailTextField.text ?? ""
        let phoneNumber = createProfileScreen.phoneNumberTextField.text ?? ""
        let address = createProfileScreen.addressTextField.text ?? ""
        let cityState = createProfileScreen.cityStateTextField.text ?? ""
        let zip = createProfileScreen.zipTextField.text ?? ""
        
        if !isValidEmail(email: email) {
            showAlert(message: "The email format is invalid.")
        }
        
        if !isValidPhoneNumber(phoneNumber: phoneNumber) {
            return
        }
        
        if !isValidCityState(cityState: cityState) {
            return
        }
        
        if !isValidZipCode(zip: zip) {
            return
        }
        
        let showProfileScreenViewController = ShowProfileScreenViewController()
        let profile = Profile(name: name,
                              email: email,
                              phoneType: selectedPhoneType,
                              phoneNumber: phoneNumber,
                              address: address,
                              cityState: cityState,
                              zip: zip)
        
        showProfileScreenViewController.profileData = profile
        navigationController?.pushViewController(showProfileScreenViewController, animated: true)
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return phoneType.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // on change selection, update selectedMood...
        selectedPhoneType = phoneType[row]
        return phoneType[row]
    }
}
