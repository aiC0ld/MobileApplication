//
//  AddContactViewController.swift
//  WA4_Han_4294
//
//  Created by Xinyue Han on 10/6/24.
//

import UIKit
import PhotosUI

class AddContactViewController: UIViewController {
    
    var delegate: ViewController!
    
    let addContactScreen = AddContactView()
    
//    let phoneTypes = ["Cell", "Work", "Home"]
    var selectedPhoneType = "Home"
    
    var pickedImage:UIImage? = UIImage(systemName:"person.fill")
    
    override func loadView() {
        view = addContactScreen
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func hideKeyboardOnTap(){
        view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        addContactScreen.phonePicker.dataSource = self
//        addContactScreen.phonePicker.delegate = self
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self,action: #selector(onSaveBarButtonTapped)
//        )
        title = "Add Contact"
        addContactScreen.buttonSelectPhoneType.menu = getMenuTypes()
        
        addContactScreen.buttonTakePhoto.menu = getMenuImagePicker()
        addContactScreen.buttonSave.addTarget(self, action: #selector(onSaveBarButtonTapped), for: .touchUpInside)
    }
    
    func getMenuTypes() -> UIMenu{
        var menuItems = [UIAction]()
        
        for type in PhoneType.types{
            let menuItem = UIAction(title: type,handler: {(_) in
                                self.selectedPhoneType = type
                                self.addContactScreen.buttonSelectPhoneType.setTitle(self.selectedPhoneType, for: .normal)
                            })
            menuItems.append(menuItem)
        }
        
        return UIMenu(title: "Select Label", children: menuItems)
    }
    
    func getMenuImagePicker() -> UIMenu{
        var menuItems = [
            UIAction(title: "Camera",handler: {(_) in
                self.pickUsingCamera()
            }),
            UIAction(title: "Gallery",handler: {(_) in
                self.pickPhotoFromGallery()
            })
        ]
        
        return UIMenu(title: "Select source", children: menuItems)
    }
    
    //MARK: take Photo using Camera...
    func pickUsingCamera(){
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.allowsEditing = true
        cameraController.delegate = self
        present(cameraController, animated: true)
    }
    
    //MARK: pick Photo using Gallery...
    func pickPhotoFromGallery(){
        var configuration = PHPickerConfiguration()
        configuration.filter = PHPickerFilter.any(of: [.images])
        configuration.selectionLimit = 1
        
        let photoPicker = PHPickerViewController(configuration: configuration)
        
        photoPicker.delegate = self
        present(photoPicker, animated: true, completion: nil)
    }
    
    @objc func onSaveBarButtonTapped() {
        if !noEmptyFileds() {
            return
        }
        
//        let phoneNumber = addContactScreen.phoneNumberTextField.text ?? ""
        let name = addContactScreen.nameTextField.text!
        let email = addContactScreen.emailTextField.text!
        let phoneNumber = addContactScreen.phoneNumberTextField.text!
        let address = addContactScreen.addressTextField.text!
        let cityState = addContactScreen.cityStateTextField.text!
        let zip = addContactScreen.zipTextField.text!
        
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
        
        let newContact = Contact(name: name,
                                 email: email,
                                 phoneType: selectedPhoneType,
                                 phoneNumber: Int(phoneNumber),
                                 address: address,
                                 cityState: cityState,
                                 zip: zip,
                                 image: pickedImage ?? (UIImage(systemName: "photo"))!
        )
        
        self.delegate.delegateOnAddContact(newContact)
        self.navigationController?.popViewController(animated: true)
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
        if addContactScreen.nameTextField.text?.isEmpty == true {
            showAlert(message: "Name cannot be empty")
            return false
        } else if addContactScreen.emailTextField.text?.isEmpty == true {
            showAlert(message: "Email cannot be empty")
            return false
        } else if addContactScreen.phoneNumberTextField.text?.isEmpty == true {
            showAlert(message: "Phone number cannot be empty")
            return false
        } else if addContactScreen.addressTextField.text?.isEmpty == true {
            showAlert(message: "Address cannot be empty")
            return false
        } else if addContactScreen.cityStateTextField.text?.isEmpty == true {
            showAlert(message: "City cannot be empty")
            return false
        } else if addContactScreen.zipTextField.text?.isEmpty == true {
            showAlert(message: "Zip cannot be empty")
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

//extension AddContactViewController: UIPickerViewDataSource, UIPickerViewDelegate {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return PhoneType.types.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        selectedPhoneType = PhoneType.types[row]
//        return PhoneType.types[row]
//    }
//}


//MARK: adopting required protocols for PHPicker...
extension AddContactViewController:PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        print(results)
        
        let itemprovider = results.map(\.itemProvider)
        
        for item in itemprovider{
            if item.canLoadObject(ofClass: UIImage.self){
                item.loadObject(ofClass: UIImage.self, completionHandler: { (image, error) in
                    DispatchQueue.main.async{
                        if let uwImage = image as? UIImage{
                            self.addContactScreen.buttonTakePhoto.setImage(
                                uwImage.withRenderingMode(.alwaysOriginal),
                                for: .normal
                            )
                            self.pickedImage = uwImage
                        }
                    }
                })
            }
        }
    }
}

//MARK: adopting required protocols for UIImagePicker...
extension AddContactViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.editedImage] as? UIImage{
            self.addContactScreen.buttonTakePhoto.setImage(
                image.withRenderingMode(.alwaysOriginal),
                for: .normal
            )
            self.pickedImage = image
        }else{
            // Do your thing for No image loaded...
        }
    }
}
