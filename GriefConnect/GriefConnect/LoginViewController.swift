//
//  LoginViewController.swift
//  GriefConnect
//
//  Created by Shaina Sweeney on 9/25/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {

    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        registerNewUser()
    }
    
    
    func registerNewUser() {
        
        let email = usernameTextField.text!
        let password = passwordTextField.text!
        
        DatabaseAPI.shared.checkIfEmailExists(with: email, completion: {[weak self] exists in
            guard let strongSelf = self else {
                return
            }
            guard !exists else{
                strongSelf.error(message: "This email already exists. Please use another email address")
                return
            }
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { authResults, error in
                guard authResults != nil, error == nil else{
                    return
                }
                DatabaseAPI.shared.postNewUser(with: User(username: email), completion: { success in
                    let user = User(username: email)
                    print("New user is created! :)")
                })
            })
        })
        
    }

    func error(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

}
