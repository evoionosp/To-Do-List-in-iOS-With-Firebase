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

    var unpinItems: [Item] = []
    var pinItems: [Item] = []
    
    struct Category {
        let name : String
        var items : [Item]
    }

    var sections = [Category]()
    private static let cellIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        AppDelegate.firebaseDataRef.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.pinItems.removeAll()
                self.unpinItems.removeAll()
                
                //iterating through all the values
                for items in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let item = items.value as? [String: AnyObject]
                    let title  = item?["title"]
                    let desc  = item?["desc"]
                    let id  = item?["id"]
                    let isDone = item?["isDone"]
                    let isFav = item?["isFav"]
                    
                    //creating artist object with model and fetched values
                    let itemObj = Item(id: id as! String?, title: title as! String?, desc: desc as! String?, isDone: isDone as! Bool?, isFav: isFav as! Bool?)
                    
                    //appending it to list
                    if(itemObj.isFav!){
                        self.pinItems.append(itemObj)
                    } else {
                        self.unpinItems.append(itemObj)
                    }
                    
                }
                
                self.sections = [Category(name:"Pinned Items", items:self.pinItems),
                            Category(name:"Items", items:self.unpinItems)]
                
                
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
            let titleTextField = alert.textFields![0]
            let descTextField = alert.textFields![1]
            if((titleTextField.text?.isEmpty)! || (descTextField.text?.isEmpty)!){
                return
            }
            let key = AppDelegate.firebaseDataRef.childByAutoId().key!
            //creating artist with the given values
            let item = ["id":key,
                        "title": titleTextField.text! as String,
                        "desc": descTextField.text! as String,
                        "isDone": false,
                        "isFav": false
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
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Write Item Description"
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
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let items = self.sections[section].items
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ToDoListController.cellIdentifier,
            for: indexPath) 
        
        let items = self.sections[indexPath.section].items
        
        cell.textLabel?.text = items[indexPath.row].title
        cell.detailTextLabel?.text = items[indexPath.row].desc
        cell.textLabel?.alpha = items[indexPath.row].isDone! ? 0.5 : 1
        cell.textLabel?.alpha = items[indexPath.row].isDone! ? 0.5 : 1
        return cell

        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
 /*     var textField: UITextField!
        let alert = UIAlertController(title: "Edit Item",
                                      message: "Edit To Do list item",
                                      preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Update", style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            
            print(textField.text!)
            let key = self.sections[indexPath.section].items[indexPath.row].id!
            //creating artist with the given values
            let item = ["id":key,
                        "title": textField.text! as String,
                        "isDone": self.sections[indexPath.section].items[indexPath.row].isDone!,
                        "isFav": self.sections[indexPath.section].items[indexPath.row].isFav!
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
        textField.text = self.sections[indexPath.section].items[indexPath.row].title
        present(alert, animated: true, completion: nil) */
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController]
        // Pass the selected obiect to the new view controller
        let tableViewCell = sender as! UITableViewCell
        let indexPath  = tableView.indexPath(for: tableViewCell)!
        let item = self .sections[indexPath.section].items[indexPath.row]
        
        let newVC = segue.destination as! DetailViewController
        newVC.title = item.title
        newVC.item = item
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
        AppDelegate.firebaseDataRef.child(self.sections[indexPath.section].items[indexPath.row].id!).removeValue()
           // tableView.deleteRows(at: [indexPath], with: .fade)

        }
        
        let pin = UITableViewRowAction(style: .default, title: "Pin") { (action, indexPath) in
            // share item at indexPath
            
            let tmp = self.sections[indexPath.section].items[indexPath.row]
            //creating artist with the given values
            let item = ["id":tmp.id!,
                        "title": tmp.title! as String,
                        "desc": tmp.desc! as String,
                        "isDone": tmp.isDone!,
                        "isFav": true
                ] as [String : Any]
            
            AppDelegate.firebaseDataRef.child(tmp.id!).setValue(item)
            print("Pinned")
        }
        
        let unpin = UITableViewRowAction(style: .default, title: "Un-Pin") { (action, indexPath) in
            // share item at indexPath
            
            let tmp = self.sections[indexPath.section].items[indexPath.row]
            //creating artist with the given values
            let item = ["id":tmp.id!,
                        "title": tmp.title! as String,
                        "desc": tmp.desc! as String,
                        "isDone": tmp.isDone!,
                        "isFav": false
                ] as [String : Any]
            
            AppDelegate.firebaseDataRef.child(tmp.id!).setValue(item)
            print("Pinned")
        }
        
        unpin.backgroundColor = UIColor.lightGray
        pin.backgroundColor = self.view.tintColor
    
        if(indexPath.section == 0){
            return [delete, unpin]
        } else {
            return [delete, pin]
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
         let tmp = self.sections[indexPath.section].items[indexPath.row]
        
        let mDone = UIContextualAction(style: .normal, title:  "Completed", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let tmp = self.sections[indexPath.section].items[indexPath.row]
            //creating artist with the given values
            let item = ["id":tmp.id!,
                        "title": tmp.title! as String,
                        "isDone": true,
                        "isFav": tmp.isFav!
                ] as [String : Any]
            
            AppDelegate.firebaseDataRef.child(tmp.id!).setValue(item)
            print("Done")
        })
        let mUndone = UIContextualAction(style: .normal, title:  "Incomplete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let tmp = self.sections[indexPath.section].items[indexPath.row]
            //creating artist with the given values
            let item = ["id":tmp.id!,
                        "title": tmp.title! as String,
                        "isDone": false,
                        "isFav": tmp.isFav!
                ] as [String : Any]
            
            AppDelegate.firebaseDataRef.child(tmp.id!).setValue(item)
            print("UnDone")
        })
        mUndone.backgroundColor = UIColor.lightGray
        mDone.backgroundColor = self.view.tintColor
        
        if (tmp.isDone!){
            return UISwipeActionsConfiguration(actions: [mUndone])
        } else {
            return UISwipeActionsConfiguration(actions: [mDone])
        }
        
        
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
}
