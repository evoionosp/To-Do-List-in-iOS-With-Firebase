//
//  DetailViewController.swift
//  To Do List App
//
//  Created by Shubh Patel on 2018-12-06.
//  Copyright © 2018 Shubh Patel. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    

    var item: Item = Item()
    
    
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfDesc: UITextView!
    @IBOutlet weak var switchDone: UISwitch!
    @IBOutlet weak var switchPin: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfTitle.text = item.title
        tfDesc.text = item.desc
    
        switchDone.setOn(item.isDone!, animated: true)
        
        switchPin.setOn(item.isFav!, animated: true)

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onSaveClick(_ sender: UIButton) {
        
        let item = ["id": self.item.id!,
                    "title": tfTitle.text! as String,
                    "desc": tfDesc.text! as String,
                    "isDone": switchDone.isOn,
                    "isFav": switchPin.isOn
            ] as [String : Any]
        
        AppDelegate.firebaseDataRef.child(self.item.id!).setValue(item)
        
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
