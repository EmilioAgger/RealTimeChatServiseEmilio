//
//  ChatRoomVC.swift
//  ChatService
//
//  Created by Bruger on 05/07/2020.
//  Copyright © 2020 Bruger. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

import FirebaseDatabase


class ChatRoomVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var ChatNavigationItem: UINavigationItem!
    @IBOutlet weak var MessageChatView: UITextView!
    @IBOutlet weak var WriteMessageToChat: UITextField!
    
    @IBAction func DismissKeyboardIfTapped(_ sender: Any) {
        dismissKeyboard()
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        view.endEditing(false)
        
        // Sætter Storyboard NavigationItem title til Brugers navn
        let LoginUser = FirebaseAuth.Auth.auth().currentUser?.displayName ?? "Bruger findes ikke"
        self.ChatNavigationItem.title = "User: \(LoginUser)"
        
        // Henter data fra DB og sætter dem til Textview
        ShowMessageFromFireStore()
        
        WriteMessageToChat.delegate = self
        WriteMessageToChat.becomeFirstResponder()
    }
    
    func ShowMessageFromFireStore(){
        
        ref?.child("messages").observe(DataEventType.value, with: { (DataSnapshot) in
            self.MessageChatView.text = ""
            let messageDictionary = DataSnapshot.value as? [String: String] ?? [:]
            let sorted = Array(messageDictionary.keys).sorted(by: <)
            for key in sorted {
                let message = messageDictionary[key]!
                self.MessageChatView.text = self.MessageChatView.text + "\n" + message
            }
            let range = NSMakeRange(self.MessageChatView.text.count - 1, 0)
            self.MessageChatView.scrollRangeToVisible(range)
        }, withCancel:  nil)
    }
    
    // Knappen der sender til Database
    @IBAction func SendMessage(_ sender: Any) {
        
        
        if (WriteMessageToChat.text != "") {
            
            
            // Henter User fra Database wia Ref
            let NameSender = FirebaseAuth.Auth.auth().currentUser?.displayName ?? "Anonymous User"
            //Skrive til Database med WriteMessageToChat
            let MessageText = NameSender + ": " + WriteMessageToChat.text!
            let key = ref.child("messages").childByAutoId().key
            let updates = ["/messages/\(key ?? " | | ")": MessageText]
            ref.updateChildValues(updates)
            WriteMessageToChat.text = ""
            
        }else {
            let warning = UIAlertController(
                title: "Der skete en fejl",
                message: "Text feltet er tomt",
                preferredStyle: .alert)
            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            warning.addAction(cancel)
            self.present(warning, animated: true)
        }
    }
    
    // Logger ud af Bruger
    @IBAction func SignOut(_ sender: Any) {
        
        func signOutDB(){
            try! FirebaseAuth.Auth.auth().signOut()
            print("Bruger Logget Ud")
            dismiss(animated: false, completion: nil)
        }
        
        let warning = UIAlertController(
            title: "Log ud ",
            message: "Er du sikker på du ville logge ud",
            preferredStyle: .alert)
        
        let dontLogoutBTN = UIAlertAction(title: "Nej", style: .cancel, handler: nil)
        let logoutBTN = UIAlertAction(title: "Ja", style: .default) { (action) in
            signOutDB()
        }
        warning.addAction(dontLogoutBTN)
        warning.addAction(logoutBTN)
        
        self.present(warning, animated: true)
        
    }
}
