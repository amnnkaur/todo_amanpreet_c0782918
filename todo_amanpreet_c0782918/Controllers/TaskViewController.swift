//
//  ViewController.swift
//  todo_amanpreet_c0782918
//
//  Created by Aman Kaur on 2020-06-23.
//  Copyright © 2020 Aman Kaur. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {
    
    var selectedNote: Tasks? {
            didSet{
                // write code later
                editMode = true
            }
        }
       
        var editMode: Bool = false
        
    // delegate for noteTable VC
        var delegate: TasksTableViewController?


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

