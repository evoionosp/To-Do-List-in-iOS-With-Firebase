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
    var desc: String?
        var isDone: Bool?
        var isFav: Bool?
        
    init(id: String?, title: String?, desc: String?, isDone: Bool?, isFav: Bool?){
            self.id = id
            self.title = title
            self.desc = desc
            self.isDone = isDone
            self.isFav = isFav
        }
    
    init() {
        
    }

}
