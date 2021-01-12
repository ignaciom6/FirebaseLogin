//
//  NewClientViewController.swift
//  FirebaseLogin
//
//  Created by Ignacio on 12/01/2021.
//

import UIKit
import FirebaseDatabase

class NewClientViewController: UIViewController {

    @IBOutlet var nameTf: UITextField!
    @IBOutlet var lastnameTf: UITextField!
    @IBOutlet var ageTf: UITextField!
    @IBOutlet var birthdateTf: UITextField!
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDatePicker()
        
        nameTf.delegate = self
        lastnameTf.delegate = self
        ageTf.delegate = self
        birthdateTf.delegate = self
    }
    
    func createDatePicker() {
        datePicker.datePickerMode = .date
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBt = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBt], animated: true)
        
        birthdateTf.inputAccessoryView = toolbar
        birthdateTf.inputView = datePicker
    }
    
    @objc func donePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        birthdateTf.text = dateFormatter.string(from: datePicker.date)
        birthdateTf.resignFirstResponder()
    }
    
    @IBAction func savePressed(_ sender: Any) {
        if allFieldsCompleted() {
            let client = Client(name: nameTf.text ?? "", lastname: lastnameTf.text ?? "", age: ageTf.text ?? "", birthdate: birthdateTf.text ?? "")
            RealtimeDatabaseManager.saveNewClient(client: client)
            cleanAllFields()
            showAlert(withTitle: "Listo", andMessage: "Cliente guardado")
        } else {
            showAlert(withTitle: "Error", andMessage: "Debes completar todos los campos")
        }
    }
    
    func allFieldsCompleted() -> Bool {
        var completed = false
        if nameTf.text?.count ?? 0 > 0 && lastnameTf.text?.count ?? 0 > 0 && ageTf.text?.count ?? 0 > 0 && birthdateTf.text?.count ?? 0 > 0 {
            completed = true
        }
        return completed
    }
    
    func cleanAllFields() {
        nameTf.text?.removeAll()
        lastnameTf.text?.removeAll()
        ageTf.text?.removeAll()
        birthdateTf.text?.removeAll()
    }
    
    func showAlert(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}




extension NewClientViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTf:
            lastnameTf.becomeFirstResponder()
        case lastnameTf:
            ageTf.becomeFirstResponder()
        case ageTf:
            birthdateTf.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case ageTf:
            let allowed = CharacterSet(charactersIn:"0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            return allowed.isSuperset(of: characterSet)
        default:
            break
        }
        return true
    }
}
