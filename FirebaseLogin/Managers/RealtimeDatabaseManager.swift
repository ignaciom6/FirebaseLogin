//
//  RealtimeDatabaseManager.swift
//  FirebaseLogin
//
//  Created by Ignacio on 12/01/2021.
//

import UIKit
import FirebaseDatabase

class RealtimeDatabaseManager: NSObject {
    
    class func saveNewClient(client: Client) {
        let ref = Database.database().reference()
        ref.child(client.name + client.lastname + client.age + client.birthdate).setValue(["name" : client.name,
                                                                                           "lastname" : client.lastname,
                                                                                           "age" : client.age,
                                                                                           "birthdate" : client.birthdate])
    }

}
