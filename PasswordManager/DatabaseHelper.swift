//
//  DatabaseHelper.swift
//  PasswordManagerApp
//
//  Created by Apple on 25/08/24.
//
import Security
import RealmSwift
import UIKit

class DatabaseHelper{
    
    static let shared = DatabaseHelper()
    
    private var realm = try! Realm()
    
    func getDatabasePath() -> URL?{
        return Realm.Configuration.defaultConfiguration.fileURL
    }
    
    func savePassword(passwordmanager : PasswordManager)  {
        try! realm.write
        {realm.add(passwordmanager)
        }
    }
    
    func updatePassword(oldPassword: PasswordManager, newPassword: PasswordManager){
        try! realm.write{
            //Yogesh = Pratik(BOSS)
            oldPassword.accountname = newPassword.accountname
            oldPassword.username = newPassword.username
            oldPassword.password = newPassword.password
        }
    }
    
    func deletePassword(passwordmanager : PasswordManager){
        try! realm.write{
            realm.delete(passwordmanager)
        }
    }
    
    func getAllPassword() -> [PasswordManager]{
        return Array(realm.objects(PasswordManager.self))
    }
}
