//
//  ViewController.swift
//  PasswordManagerApp
//
//  Created by Apple on 24/08/24.
//
import Security
import RealmSwift
import UIKit

class PasswordManager : Object {
    @objc dynamic var accountname : String = ""
    @objc dynamic var username: String  = ""
    @objc dynamic var password : String = ""
    
    convenience   init(accountname:String, username:String , password:String) {
        self.init()
        self.accountname = accountname
        self.username = username
        self.password = password
    }
}


class ViewController: UIViewController {
    
    @IBOutlet weak var passordManagerTableView: UITableView!
    var passwordManagerArray = [PasswordManager]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Confuguration()
    }
        
    
    @IBAction func passwordManagerTapped(_ sender: UIBarButtonItem) {
        passwordConfiguration(isadd: true, index: 0)
    }
    
}


extension ViewController {
    
    func Confuguration() {
        passordManagerTableView.dataSource = self
        passordManagerTableView.delegate = self
        passordManagerTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        passwordManagerArray = DatabaseHelper.shared.getAllPassword()
    }
    
    func passwordConfiguration(isadd:Bool,index:Int)  {
        let alert = UIAlertController(title: isadd ? "Add New Account": "Update Password", message: isadd ? "Please Enter Your Details" : "Please update your Password", preferredStyle: .alert)
        
        let save = UIAlertAction(title: isadd ? "Save" : "Update", style: .default) { _ in
            
            if let accountname = alert.textFields?.first?.text,
               let username = alert.textFields?[1].text,
               let password = alert.textFields?[2].text{
                
                let passwordManager = PasswordManager(accountname: accountname, username : username, password: password)
                
                if isadd {
                    self.passwordManagerArray.append(passwordManager)
                    DatabaseHelper.shared.savePassword(passwordmanager: passwordManager)
                }else{
                    //   self.passwordManagerArray[index] = passwordManager
                    DatabaseHelper.shared.updatePassword(oldPassword: self.passwordManagerArray[index], newPassword: passwordManager)
                }
                
                self.passordManagerTableView.reloadData()
            }
        }
        
        let cancle = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
        
        alert.addTextField { accountname in
            accountname.placeholder = isadd ? "Please Enter AccountName" : self.passwordManagerArray[index].accountname
        }
        
        alert.addTextField { username in
            
            username.placeholder = isadd ? "Please Enter UserName" : self.passwordManagerArray[index].username
        }
        
        alert.addTextField { password in
            
            password.placeholder = isadd ? "Please Enter Password" : self.passwordManagerArray[index].password
        }
        
        alert.addAction(save)
        alert.addAction(cancle)
        present(alert, animated: true)
    }
}


extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        passwordManagerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard var cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
        
        cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = passwordManagerArray[indexPath.row].accountname
        cell.detailTextLabel?.text = passwordManagerArray[indexPath.row].username
        cell.detailTextLabel?.text = passwordManagerArray[indexPath.row].password
        return cell
    }
}


extension ViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
            self.passwordConfiguration(isadd: false, index: indexPath.row)
        }
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            DatabaseHelper.shared.deletePassword(passwordmanager: self.passwordManagerArray[indexPath.row])
            self.passwordManagerArray.remove(at: indexPath.row)
            self.passordManagerTableView.reloadData()
        }
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [delete,edit])
        return swipeConfiguration
    }
    
}








