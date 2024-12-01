//
//  NoteViewController.swift
//  App10
//
//  Created by Xinyue Han on 11/3/24.
//

import UIKit

class NoteViewController: UIViewController {
    
    let detailScreen = NoteScreenView()
    var receivedNote: Note?
    
    let notificationCenter = NotificationCenter.default
    
    override func loadView() {
        view = detailScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Note"
        displayNote()
    }
    
    func displayNote() {
        if let note = receivedNote {
            detailScreen.labelNoteText.text = note.text
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
