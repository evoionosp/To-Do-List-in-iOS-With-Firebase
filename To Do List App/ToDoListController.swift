//
//  ToDoListController.swift
//  To Do List App
//
//  Created by Shubh Patel on 2018-11-26.
//  Copyright © 2018 Shubh Patel. All rights reserved.
//

import UIKit
import Firebase

class ToDoListController: UITableViewController {

    var listItems: [Item] = []

    private static let cellIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        AppDelegate.firebaseDataRef.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.listItems.removeAll()
                
                //iterating through all the values
                for items in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let item = items.value as? [String: AnyObject]
                    let title  = item?["title"]
                    let id  = item?["id"]
                    let isDone = item?["isDone"]
                    
                    //creating artist object with model and fetched values
                    let itemObj = Item(id: id as! String?, title: title as! String?, isDone: isDone as! Bool?)
                    
                    //appending it to list
                    self.listItems.append(itemObj)
                }
                
                //reloading the tableview
                self.tableView.reloadData()
            }
        })
    }
    
    @IBAction func AddItem(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add Item",
                                      message: "Add new item to To Do List",
                                      preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Add", style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            let textField = alert.textFields![0]
            print(textField.text!)
            let key = AppDelegate.firebaseDataRef.childByAutoId().key!
            //creating artist with the given values
            let item = ["id":key,
                        "title": textField.text! as String,
                        "isDone": false
                ] as [String : Any]
            //adding the artist inside the generated unique key
            AppDelegate.firebaseDataRef.child(key).setValue(item)
            
            //displaying message
            
            print("To DO Item Added")
            
        })
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Write To Do Item here"
            textField.clearButtonMode = .whileEditing
        }
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if showFavourites {
//            fontNames = FavoritesList.sharedFavoritesList.favorites
//            tableView.reloadData()
//        }
        
    }
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return listItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ToDoListController.cellIdentifier,
            for: indexPath) as! MyTableViewCell
       
       // cell.doneSwitch.tag = indexPath.row
        cell.textLabel?.text = listItems[indexPath.row].title
        cell.doneSwitch.isOn = listItems[indexPath.row].isDone!
        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var textField: UITextField!
        let alert = UIAlertController(title: "Edit Item",
                                      message: "Edit To Do list item",
                                      preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Update", style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            
            print(textField.text!)
            let key = self.listItems[indexPath.row].id!
            //creating artist with the given values
            let item = ["id":key,
                        "title": textField.text! as String,
                        "isDone": false
                ] as [String : Any]
            //adding the artist inside the generated unique key
            AppDelegate.firebaseDataRef.child(key).setValue(item)
            
            //displaying message
            
        })
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Write To Do Item here"
            textField.clearButtonMode = .whileEditing
        }
        alert.addAction(submitAction)
        alert.addAction(cancel)
        
        textField = alert.textFields![0]
        textField.text = self.listItems[indexPath.row].title
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
           }
}
