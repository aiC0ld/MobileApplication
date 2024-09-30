//
//  ShowProfileScreenViewController.swift
//  WA3_Han_4294
//
//  Created by Xinyue Han on 9/27/24.
//

import UIKit

class ShowProfileScreenViewController: UIViewController {
    
    let showProfileScreen = ShowProfileScreenView()
    
    override func loadView() {
        view = showProfileScreen
    }

    var profileData: ViewController.Profile = ViewController.Profile()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let unwrappedName = profileData.name{
            if !unwrappedName.isEmpty{
                showProfileScreen.nameLabel.text = "Name: \(unwrappedName)"
            }
        }
        
        if let unwrappedEmail = profileData.email{
            if !unwrappedEmail.isEmpty{
                showProfileScreen.emailLabel.text = "Email: \(unwrappedEmail)"
            }
        }
        
        if let unwrappedPhoneNumber = profileData.phoneNumber{
            if !unwrappedPhoneNumber.isEmpty{
                showProfileScreen.phoneLabel.text = "Phone: \(unwrappedPhoneNumber)"
            }
        }
        
        if let unwrappedAddress = profileData.address{
            if !unwrappedAddress.isEmpty{
                showProfileScreen.addressLabel.text = "Address: \(unwrappedAddress)"
            }
        }
        
        if let unwrappedCityState = profileData.cityState{
            if !unwrappedCityState.isEmpty{
                showProfileScreen.cityStateLabel.text = "\(unwrappedCityState)"
            }
        }
        
        if let unwrappedZip = profileData.zip{
            if !unwrappedZip.isEmpty{
                showProfileScreen.zipLabel.text = "ZIP: \(unwrappedZip)"
            }
        }
        
        if let unwrappedPhoneType = profileData.phoneType {
            showProfileScreen.phoneTypeImage.image = UIImage(named: unwrappedPhoneType.lowercased())
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
