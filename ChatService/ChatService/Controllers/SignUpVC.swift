//
//  SignUpVC.swift
//  ChatService
//
//  Created by Bruger on 05/07/2020.
//  Copyright © 2020 Bruger. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpVC: UIViewController {
    
    @IBOutlet weak var UserNameField: UITextField!
    @IBOutlet weak var UserEmailField: UITextField!
    @IBOutlet weak var UserPasswordField: UITextField!
    
    @IBAction func DismissKeyboardIfTapped(_ sender: Any) {
        dismissKeyboard()
    }
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.endEditing(false)
        ref = Database.database().reference()
    }
    
    @IBAction func CreateNewUser(_ sender: Any) {
        
        if let email = UserEmailField.text, let password = UserPasswordField.text {
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { user, error in
                // Alert hvis bruger ikke oprettes
                if let eror = error {
                    let warning = UIAlertController(
                        title: "Ikke Opfyldt",
                        message: eror.localizedDescription,
                        preferredStyle: .alert)
                    
                    let Cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    warning.addAction(Cancel)
                    self.present(warning, animated: true)
                    
                } else {
                    if let _ = user {
                        let usersData = [
                            "Name" : self.UserNameField.text! as String,
                            "Email" : self.UserEmailField.text! as String,
                            "Password" : self.UserPasswordField.text! as String
                        ]
                        guard let UserID = FirebaseAuth.Auth.auth().currentUser?.uid else { return }
                        self.ref.child("Users").child(UserID).setValue([usersData])
                        
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = self.UserNameField.text
                        changeRequest?.commitChanges { (error) in
                            print("error")
                        }
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
