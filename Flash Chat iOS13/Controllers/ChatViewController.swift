//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages : [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessage()
    }
    func loadMessage(){
        db.collection("data")
        .order(by: "date")
            .addSnapshotListener { (querySnapshot, error) in
            self.messages = []
            if let err = error{
                print(err)
            }else{
                if let snapshotDocumment = querySnapshot?.documents{
                    for doc in snapshotDocumment{
                        let data = doc.data()
                        if let sender = data["email"] as? String, let message = data["message"] as? String{
                            print(sender)
                            print(message)
                            let item = Message(sender: sender, body: message)
                            self.messages.append(item)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func onSignoutPressed(_ sender: UIBarButtonItem) {
        let auth = Auth.auth()
        do{
            try auth.signOut()
            navigationController?.popToRootViewController(animated: true)
        }catch let signOutError as NSError{
            print(signOutError)
        }
    }
    @IBAction func sendPressed(_ sender: UIButton) {
        if let message =  messageTextfield.text, let email = Auth.auth().currentUser?.email{
            var ref : DocumentReference? = nil
            ref = db.collection("data").addDocument(data: [
                "email" : email,
                "message" : message,
                "date" : Date().timeIntervalSince1970
            ]){error in
                if let err = error {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        }
    }
  
    

}
extension ChatViewController : UITableViewDelegate{
    
}
extension ChatViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
         as! MessageCellTableViewCell
        
        cell.label.text = messages[indexPath.row].body
        
        return cell
    }
    
    
}
