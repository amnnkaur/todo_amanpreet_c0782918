//
//  ViewController.swift
//  todo_amanpreet_c0782918
//
//  Created by Aman Kaur on 2020-06-23.
//  Copyright © 2020 Aman Kaur. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {
    
    
    var taskTitle: String?
    var days: String?
    var date: Date?

    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var noOfDays: UITextField!
    @IBOutlet weak var dateTxtField: UITextField!
    
    
    var tasks = [Tasks]()
    
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
        addDatePicker()
    }

    func addDatePicker(){
           
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.dateAndTime
        dateTxtField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(TaskViewController.datePickerValueChanged), for: UIControl.Event.valueChanged)
        
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {

        let dateFormatter = DateFormatter()

        dateFormatter.dateStyle = DateFormatter.Style.medium

        dateFormatter.timeStyle = DateFormatter.Style.short

        dateTxtField.text = dateFormatter.string(from: sender.date)

    }
    
    @IBAction func addTask(_ sender: UIButton) {
        
      
              
                    
          }
          
          func showAlert() {
               let alert = UIAlertController(title: "Alert", message: "Task Name already Exist", preferredStyle: .alert)
               let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
               okAction.setValue(UIColor.orange, forKey: "titleTextColor")
               alert.addAction(okAction)
               present(alert, animated: true, completion: nil)
           }
        
        
    
    
}

