//
//  LogInVC.swift
//  ChatService
//
//  Created by Bruger on 05/07/2020.
//  Copyright © 2020 Bruger. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LogInVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.endEditing(false)
    }
    
    // Felt for Email Login
    @IBOutlet weak var LoginEmailField: UITextField!
    
    // Felt for Password Login
    @IBOutlet weak var LoginPasswordField: UITextField!
    
    @IBAction func DismissKeyboardIfTapped(_ sender: Any) {
        dismissKeyboard()
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func SignInUser(_ sender: Any) {
        
        if let Email = LoginEmailField.text, let Password = LoginPasswordField.text {
            
            FirebaseAuth.Auth.auth().signIn(withEmail: Email, password: Password) { user, error in
                
                if error == nil {
                    // sender videre til segue fra Storyboardet
                    self.performSegue(withIdentifier: "ToChatRoom", sender: nil)
                    print("Succes")
                    // sætter login textfield = ""
                    self.LoginEmailField.text = ""
                    self.LoginPasswordField.text = ""
                    
                } else {
                    if let eror = error {
                        
                        let warning = UIAlertController(
                            title: "Mangler noget",
                            message: eror.localizedDescription,
                            preferredStyle: .alert)
                        
                        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        warning.addAction(cancel)
                        self.present(warning, animated: true)
                        
                        
                    }
                }
            }
        }
    }
}
