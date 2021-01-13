//
//  ViewController.swift
//  FirebaseLogin
//
//  Created by Ignacio on 11/01/2021.
//

import UIKit
import FBSDKLoginKit
import Firebase

class LoginViewController: UIViewController {
    
    let kLoginSuccessSegue = "LoginSuccess"
    let kErrorTitle = "Error"
    let kOkAction = "Ok"
    let kAccessError = "Debes dar acceso"
    @IBOutlet var newClientBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFacebookBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        newClientBtn.isHidden = AccessToken.current != nil ? false : true
    }
    
    func configureFacebookBtn() {
        let fbBtn = FBLoginButton()
        fbBtn.delegate = self
        fbBtn.center = view.center
        
        self.view.addSubview(fbBtn)
    }
    
    @IBAction func newClientPressed(_ sender: Any) {
        self.performSegue(withIdentifier: kLoginSuccessSegue, sender: self)
    }
    
    func showAlert(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: kOkAction, style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}



extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            showAlert(withTitle: kErrorTitle, andMessage: error.localizedDescription)
            return
        }
        
        if AccessToken.current == nil {
            showAlert(withTitle: kErrorTitle, andMessage: kAccessError)
            return
        }

        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)

        Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(withTitle: self?.kErrorTitle ?? "Error", andMessage: error.localizedDescription)
                }
                return
            }
            DispatchQueue.main.async {
                self?.newClientBtn.isHidden = false
            }
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            newClientBtn.isHidden = true
        } catch let signOutError as NSError {
            showAlert(withTitle: kErrorTitle, andMessage: signOutError as! String)
        }
    }
    
}
