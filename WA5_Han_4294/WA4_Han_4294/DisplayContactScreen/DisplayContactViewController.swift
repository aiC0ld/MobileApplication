//
//  DisplayContactViewController.swift
//  WA4_Han_4294
//
//  Created by Xinyue Han on 10/6/24.
//

import UIKit

class DisplayContactViewController: UIViewController {
    
    let showProfileScreen = DisplayContactView()
    var delegate: ViewController!
    var currentIndexPath: IndexPath!

    override func loadView() {
        view = showProfileScreen
    }

    var profileData: Contact? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .edit, target: self,
            action: #selector(onEditBarButtonTapped)
        )
        
        display()
    }
    
    @objc func onEditBarButtonTapped() {
//        let editViewController = EditViewController()
//        editViewController.delegate = self
//        editViewController.profileData = profileData
//        navigationController?.pushViewController(editViewController, animated: true)
        
        let editViewController = EditViewController()
        editViewController.delegate = self.delegate
        editViewController.profileData = self.profileData
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.pushViewController(editViewController, animated: true)
    }
    
    func delegateOnAddContact(Contact: Contact){
        profileData = Contact
        display()
        delegate.updateTableView(update: currentIndexPath, updateContact: profileData!)
        
//        if let delegate = delegate, let currentIndexPath = currentIndexPath, let profileData = profileData {
//            delegate.updateTableView(update: currentIndexPath, updateContact: profileData)
//        } else {
//            print("Delegate, currentIndexPath, or profileData is nil")
//        }
    }
    
    func display() {
        
        showProfileScreen.imagePhoto.image = profileData?.image!
        
        if let unwrappedName = profileData?.name{
            if !unwrappedName.isEmpty{
                showProfileScreen.nameLabel.text = "\(unwrappedName)"
            }
        }
        
        if let unwrappedEmail = profileData?.email{
            if !unwrappedEmail.isEmpty{
                showProfileScreen.emailLabel.text = "Email: \(unwrappedEmail)"
            }
        }
        
        if let unwrappedPhoneNumber = profileData?.phoneNumber, let unwrappedPhoneType = profileData?.phoneType{
            showProfileScreen.phoneLabel.text = "Phone: \(unwrappedPhoneNumber) (\(unwrappedPhoneType))"
        }
        
        if let unwrappedAddress = profileData?.address{
            if !unwrappedAddress.isEmpty{
                showProfileScreen.addressLabel.text = "\(unwrappedAddress)"
            }
        }
        
        if let unwrappedCityState = profileData?.cityState{
            if !unwrappedCityState.isEmpty{
                showProfileScreen.cityStateLabel.text = "\(unwrappedCityState)"
            }
        }
        
        if let unwrappedZip = profileData?.zip{
            if !unwrappedZip.isEmpty{
                showProfileScreen.zipLabel.text = "\(unwrappedZip)"
            }
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
