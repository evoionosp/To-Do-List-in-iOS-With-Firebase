//
//  Item.swift
//  To Do List App
//
//  Created by Shubh Patel on 2018-11-27.
//  Copyright © 2018 Shubh Patel. All rights reserved.
//

import UIKit

class Item{
        
        var id: String?
        var title: String?
        var isDone: Bool?
        
        init(id: String?, title: String?, isDone: Bool?){
            self.id = id
            self.title = title
            self.isDone = isDone
        }

}
