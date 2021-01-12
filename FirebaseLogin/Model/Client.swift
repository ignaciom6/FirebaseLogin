//
//  Client.swift
//  FirebaseLogin
//
//  Created by Ignacio on 12/01/2021.
//

import UIKit

class Client: NSObject {
    var name: String
    var lastname: String
    var age: String
    var birthdate: String
    
    init(name: String, lastname: String, age: String, birthdate: String) {
        self.name = name
        self.lastname = lastname
        self.age = age
        self.birthdate = birthdate
    }

}
