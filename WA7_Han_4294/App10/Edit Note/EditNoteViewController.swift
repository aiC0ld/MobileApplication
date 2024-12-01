//
//  EditNoteViewController.swift
//  App10
//
//  Created by Xinyue Han on 11/3/24.
//

import UIKit
import Alamofire

class EditNoteViewController: UIViewController {
    
    let editScreen = EditNoteScreenView()
    
    let notificationCenter = NotificationCenter.default
    var noteToEdit: Note?
    var token = ""
    
    override func loadView() {
        view = editScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Edit"
        
        token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        editScreen.buttonSave.addTarget(self, action: #selector(onSaveButtonTapped), for: .touchUpInside)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
        setupNoteText()
    }
    
    func setupNoteText() {
        if let note = noteToEdit {
            editScreen.textFieldNote.text = note.text
        }
    }
    
    @objc func hideKeyboardOnTap(){
        view.endEditing(true)
    }
    
    @objc func onSaveButtonTapped() {
        let noteText = editScreen.textFieldNote.text ?? ""
        
        if noteText.isEmpty {
            showAlert(message: "Note cannot be empty!")
            return
        }
        
        if var originalNote = noteToEdit {
            originalNote.text = noteText
            notificationCenter.post(name: Notification.Name("fromEditScreen"), object: nil,
                                    userInfo: ["updated": originalNote, "original": noteToEdit!])
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
