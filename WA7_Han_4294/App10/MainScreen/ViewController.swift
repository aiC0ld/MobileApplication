//
//  ViewController.swift
//  App10
//
//  Created by Sakib Miazi on 5/25/23.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    let mainScreen = MainScreenView()
    let loginScreen = LoginScreenView()
    
    var notes = [Note]()
    
    var token = ""
    
    let notificationCenter = NotificationCenter.default
    
    override func loadView() {
        view = mainScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
        
        token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        mainScreen.tableViewNotes.dataSource = self
        mainScreen.tableViewNotes.delegate = self

        mainScreen.tableViewNotes.separatorStyle = .none
        mainScreen.buttonAdd.addTarget(self, action: #selector(onButtonAddTapped), for: .touchUpInside)
        
        notificationCenter.addObserver(self, selector: #selector(deleteNoteNotification(_:)), name: Notification.Name("fromDetailScreen"), object: nil)
        notificationCenter.addObserver(self, selector: #selector(editNoteNotification(_:)), name: Notification.Name("fromEditScreen"), object: nil)
        notificationCenter.addObserver(self, selector: #selector(authNotification), name: Notification.Name("fromLoginScreen"), object: nil)
        notificationCenter.addObserver(self, selector: #selector(authNotification), name: Notification.Name("fromRegisterScreen"), object: nil)
        notificationCenter.addObserver(self, selector: #selector(showLoginScreen), name: Notification.Name("fromLogoutScreen"), object: nil)
        
        updateRightBarButton()
        
        getAllNotes(token: token)
    }
    
    @objc func authNotification() {
        token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        updateRightBarButton()
        getAllNotes(token: token)
    }
    func checkLoginStatusAndShowLoginIfNeeded() {
        // Check if token exists in UserDefaults
        if UserDefaults.standard.string(forKey: "authToken") == nil {
            showLoginScreen()
        } else {
            getAllNotes(token: UserDefaults.standard.string(forKey: "authToken") ?? "")
        }
    }
    
    func updateRightBarButton() {
        if UserDefaults.standard.string(forKey: "authToken") != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(showProfileScreen))
        } else {
            // If not logged in, show loginscreen
            showLoginScreen()
        }
    }
    
    @objc func showLoginScreen() {
        let loginViewController = LoginViewController()
        loginViewController.modalPresentationStyle = .fullScreen
        present(loginViewController, animated: true, completion: nil)
    }
    @objc func showProfileScreen() {
        let detailViewController = DetailViewController()
        navigationController?.pushViewController(detailViewController, animated: true)
    }


    @objc func deleteNoteNotification(_ notification: Notification) {
        guard let note = notification.object as? Note else { return }
        deleteNote(token: UserDefaults.standard.string(forKey: "authToken") ?? "", note: note)
    }
    
    @objc func editNoteNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Note],
              let updatedNote = userInfo["updated"],
              let originalNote = userInfo["original"] else {
            return
        }
        
        editNote(token: token, updatedNote: updatedNote, originalNote: originalNote)
    }


    func clearAddViewFields(){
        mainScreen.textViewAddNote.text = ""
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func onButtonAddTapped() {
         guard let noteText = mainScreen.textViewAddNote.text, !noteText.isEmpty else {
             showAlert(message: "Note cannot be empty!")
             return
         }
         
        addANewNote(token: token, noteText: noteText)
     }

    func addANewNote(token: String, noteText: String){
        if let url = URL(string: APIConfigs.notesBaseURL + "post"){
            
            AF.request(url, method:.post,parameters:
                        [
                            "text": noteText
                        ],headers:
                        [
                            "x-access-token": token
                       ])
            .responseString(completionHandler: { response in
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
                            self.getAllNotes(token: token)
                            self.clearAddViewFields()
                            break
                            
                        case 400...499:
                            //MARK: the request was not valid 400-level...
                            print(data)
                            break
                            
                        default:
                            //MARK: probably a 500-level error...
                            print(data)
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
        }else{
            //alert that the URL is invalid...
        }
    }

    func deleteNote(token: String, note: Note){
        if let url = URL(string: APIConfigs.notesBaseURL + "delete"){
            
            AF.request(url, method:.post, parameters:
                        [
                            "id": note._id
                        ],headers: [
                       "x-access-token": token
                       ])
            .responseString(completionHandler: { response in
                let status = response.response?.statusCode
                
                switch response.result{
                case .success(let data):

                    if let uwStatusCode = status{
                        switch uwStatusCode{
                        case 200...299:
                            self.getAllNotes(token: token)
                            break
                            
                        case 400...499:
                            print(data)
                            break
                            
                        default:
                            print(data)
                            break
                            
                        }
                    }
                    break
                    
                case .failure(let error):
                    print(error)
                    break
                }
            })
        }else{
        }
    }
    
    func editNote(token: String, updatedNote: Note, originalNote: Note){
        if let url = URL(string: APIConfigs.notesBaseURL + "delete"){
            AF.request(url, method:.post, parameters:
                        [
                            "id": originalNote._id
                        ], headers: [
                       "x-access-token": token
                       ])

            .responseString(completionHandler: { response in
                let status = response.response?.statusCode
                
                switch response.result{
                case .success(let data):

                    if let uwStatusCode = status{
                        switch uwStatusCode{
                        case 200...299:
                            self.addANewNote(token: token, noteText: updatedNote.text)
                            break
                            
                        case 400...499:
                            print(data)
                            break
                            
                        default:
                            print(data)
                            break
                            
                        }
                    }
                    break
                    
                case .failure(let error):
                    print(error)
                    break
                }
            })
        }else{
        }
    }
    
    
    func getAllNotes(token: String) {
        if let url = URL(string: APIConfigs.notesBaseURL + "getall") {
            AF.request(url, method: .get, headers: ["x-access-token": token])
                .responseJSON { response in
                    let status = response.response?.statusCode
                    switch response.result {
                    case .success(let data):
                        if let uwStatusCode = status {
                            switch uwStatusCode {
                            case 200...299:
                                if let json = data as? [String: Any],
                                   let notesArray = json["notes"] as? [[String: Any]] {
                                    self.notes = notesArray.compactMap { dict -> Note? in
                                        guard let id = dict["_id"] as? String,
                                              let userId = dict["userId"] as? String,
                                              let text = dict["text"] as? String,
                                              let version = dict["__v"] as? Int else {
                                            return nil
                                        }
                                        return Note(_id: id, userId: userId, text: text, __v: version)
                                    }
                                    self.mainScreen.tableViewNotes.reloadData()
                                } else {
                                    print("Error notes")
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

    func viewSelectedFor(noteIndex: Int) {
        let note = notes[noteIndex]
        navigateToNoteDetails(note: note)
    }
    
    func editSelectedFor(noteIndex: Int) {
        let note = notes[noteIndex]
        let editNoteViewController = EditNoteViewController()
        editNoteViewController.noteToEdit = note

        self.navigationController?.pushViewController(editNoteViewController, animated: true)
    }

    
    func deleteSelectedFor(noteIndex: Int) {
         let note = notes[noteIndex]
         
         let alert = UIAlertController(title: "Delete Note",
                                       message: "Do you want to delete this note?",
                                       preferredStyle: .alert)
         
         alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
         alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
             self?.deleteNoteConfirmed(note: note)
             self?.notes.remove(at: noteIndex)
             self?.mainScreen.tableViewNotes.deleteRows(at: [IndexPath(row: noteIndex, section: 0)], with: .automatic)
         }))
         
         self.present(alert, animated: true)
     }

     func deleteNoteConfirmed(note: Note) {
         deleteNote(token: token, note: note)
     }


    func navigateToNoteDetails(note: Note) {
        let noteViewController = NoteViewController()
        noteViewController.receivedNote = note
        self.navigationController?.pushViewController(noteViewController, animated: true)
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notes", for: indexPath) as! NotesTableViewCell
        cell.labelName.text = notes[indexPath.row].text
        
        // MARK: creating an accessory button...
        let buttonOptions = UIButton(type: .system)
        buttonOptions.sizeToFit()
        buttonOptions.showsMenuAsPrimaryAction = true
        buttonOptions.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        
        // MARK: setting up menu for button options click...
        buttonOptions.menu = UIMenu(title: "Actions", children: [
            UIAction(title: "View Note", handler: { _ in
                self.viewSelectedFor(noteIndex: indexPath.row)
            }),
            UIAction(title: "Edit Note", handler: { _ in
                self.editSelectedFor(noteIndex: indexPath.row)
            }),
            UIAction(title: "Delete Note", handler: { _ in
                self.deleteSelectedFor(noteIndex: indexPath.row)
            })
        ])
        
        // Set the button as an accessory of the cell...
        cell.accessoryView = buttonOptions
        return cell
    }
}
