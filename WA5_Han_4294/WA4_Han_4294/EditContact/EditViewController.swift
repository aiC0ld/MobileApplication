//
//  EditViewController.swift
//  WA4_Han_4294
//
//  Created by Xinyue Han on 10/11/24.
//

import UIKit
import PhotosUI

class EditViewController: UIViewController {
    
    var profileData: Contact?
    var delegate: ViewController!
    
    let editView = EditView()
    var selectedPhoneType = "Home"
    var pickedImage: UIImage? = UIImage(systemName:"person.fill")
    
    override func loadView() {
        view = editView
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func hideKeyboardOnTap(){
        view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Edit"
        
        setData()
        
        editView.buttonSelectPhoneType.menu = getMenuTypes()
        
        editView.buttonTakePhoto.menu = getMenuImagePicker()
        
        editView.buttonSave.addTarget(self, action: #selector(onSaveBarButtonTapped), for: .touchUpInside)
    }
    
    func setData() {
        editView.nameTextField.text = profileData!.name
        editView.buttonTakePhoto.setImage(profileData!.image, for: .normal)
        editView.emailTextField.text = profileData!.email
        editView.phoneNumberTextField.text = "\(String(describing: profileData!.phoneNumber))"
        editView.addressTextField.text = profileData!.address
        editView.cityStateTextField.text = profileData!.cityState
        editView.zipTextField.text = profileData!.zip
        editView.buttonSelectPhoneType.setTitle(profileData!.phoneType, for: .normal)
//        selectedPhoneType = profileData!.phoneType
        pickedImage = profileData!.image
    }
    
    func getMenuTypes() -> UIMenu{
        var menuItems = [UIAction]()
        
        for type in PhoneType.types{
            let menuItem = UIAction(title: type,handler: {(_) in
                                self.selectedPhoneType = type
                                self.editView.buttonSelectPhoneType.setTitle(self.selectedPhoneType, for: .normal)
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
        
        let name = editView.nameTextField.text!
        let email = editView.emailTextField.text!
        let phoneNumber = editView.phoneNumberTextField.text!
        let address = editView.addressTextField.text!
        let cityState = editView.cityStateTextField.text!
        let zip = editView.zipTextField.text!
        
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
                                 image: pickedImage!
        )
        
        self.delegate.delegateOnEditContact(newContact)
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
        if editView.nameTextField.text?.isEmpty == true {
            showAlert(message: "Name cannot be empty")
            return false
        } else if editView.emailTextField.text?.isEmpty == true {
            showAlert(message: "Email cannot be empty")
            return false
        } else if editView.phoneNumberTextField.text?.isEmpty == true {
            showAlert(message: "Phone number cannot be empty")
            return false
        } else if editView.addressTextField.text?.isEmpty == true {
            showAlert(message: "Address cannot be empty")
            return false
        } else if editView.cityStateTextField.text?.isEmpty == true {
            showAlert(message: "City cannot be empty")
            return false
        } else if editView.zipTextField.text?.isEmpty == true {
            showAlert(message: "Zip cannot be empty")
            return false
        }
        return true
    }

}

extension EditViewController:PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        print(results)
        
        let itemprovider = results.map(\.itemProvider)
        
        for item in itemprovider{
            if item.canLoadObject(ofClass: UIImage.self){
                item.loadObject(ofClass: UIImage.self, completionHandler: { (image, error) in
                    DispatchQueue.main.async{
                        if let uwImage = image as? UIImage{
                            self.editView.buttonTakePhoto.setImage(
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
extension EditViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.editedImage] as? UIImage{
            self.editView.buttonTakePhoto.setImage(
                image.withRenderingMode(.alwaysOriginal),
                for: .normal
            )
            self.pickedImage = image
        }else{
            // Do your thing for No image loaded...
        }
    }
}
